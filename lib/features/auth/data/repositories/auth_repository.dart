import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/auth_error_mapper.dart';
import '../../../../core/role_validator.dart';

/// Thin wrapper around FirebaseAuth + GoogleSignIn + the `users` collection.
///
/// NOTE on google_sign_in ^7.x: that package made GoogleSignIn a singleton
/// (GoogleSignIn.instance) with a mandatory one-time `initialize()` call,
/// and split "authenticate" (identity/idToken) from "authorize" (scopes/
/// access tokens). Since Firebase sign-in only needs the idToken, we don't
/// request any extra scopes here. See:
/// https://github.com/flutter/packages/blob/main/packages/google_sign_in/google_sign_in/MIGRATION.md
///
/// FirebaseAuth/Firestore dependencies are still injectable for testing;
/// GoogleSignIn is not, since v7 removed the ability to construct
/// independent instances — this repository's Google sign-in path is
/// exercised manually rather than by the current unit tests.
class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  static bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await GoogleSignIn.instance.initialize();
    _googleSignInInitialized = true;
  }

  /// FirebaseAuth caches the signed-in session on-device, so this stream
  /// re-emits the current user on cold start with no extra work needed
  /// for "persistence after restart."
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  /// Creates the Firebase Auth account AND the matching Firestore
  /// `users/{uid}` profile document the rest of the app (applications,
  /// bookmarks, mentorship_sessions) reads from.
  ///
  /// [role] must be 'student' or 'mentor' — 'admin' is rejected here as a
  /// client-side safeguard, but this is defense in depth only. The real
  /// fix has to be a Firestore security rule restricting the `role` field
  /// on create; ask whoever owns firestore.rules to add it.
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    if (!RoleValidator.isValidRegistrationRole(role)) {
      throw ArgumentError.value(role, 'role', 'Must be student or mentor');
    }

    UserCredential? credential;
    try {
      credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.map(e));
    }

    final user = credential.user;
    if (user == null) return null;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'email': user.email,
        'fullName': fullName.trim(),
        'role': role,
        'bio': '',
        'profilePictureUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Don't leave an orphaned Auth account with no profile document —
      // undo the account creation and surface a clean error instead.
      await user.delete();
      throw AuthException(
        'Could not finish setting up your account. Please try again.',
      );
    }

    await user.sendEmailVerification();
    return user;
  }

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.map(e));
    }
  }

  /// Returns null if the user cancels the Google account picker.
  ///
  /// v7 API: `authenticate()` returns identity (and an ID token) without
  /// prompting for extra scopes; cancellation throws a
  /// GoogleSignInException with code `canceled` instead of returning null,
  /// so we translate that back to a null return here to keep the calling
  /// UI code simple.
  Future<User?> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();

      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Register mode also needs a users/{uid} profile document — if this
      // is the account's first Google sign-in, create one the same way
      // registerWithEmail does, defaulting to 'student'.
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        final user = userCredential.user;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'email': user.email,
            'fullName': user.displayName ?? '',
            'role': 'student',
            'bio': '',
            'profilePictureUrl': user.photoURL ?? '',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return userCredential.user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      throw AuthException('Google sign-in failed. Please try again.');
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.map(e));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.map(e));
    }
  }

  /// Call after the user taps "I've verified my email" so the cached
  /// User object picks up the latest emailVerified flag.
  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  Future<void> resendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // No-op if there was no active Google session to sign out of.
    }
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
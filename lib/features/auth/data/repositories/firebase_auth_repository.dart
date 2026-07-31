import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import 'firestore_user_repository.dart';

/// Production Implementation of [AuthRepository] using Firebase Auth & Google Sign-In.
///
/// NOTE on google_sign_in ^7.x: `GoogleSignIn` is a singleton
/// (`GoogleSignIn.instance`) that requires a one-time `initialize()` call,
/// and it can no longer be constructed independently — see the same note
/// on [AuthRepository] in data/repositories/auth_repository.dart, which
/// this class mirrors for its Google sign-in handling.
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    UserRepository? userRepository,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _userRepository = userRepository ?? FirestoreUserRepository();

  static bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await GoogleSignIn.instance.initialize();
    _googleSignInInitialized = true;
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((User? firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _userRepository.getUserById(firebaseUser.uid) ??
          _mapFirebaseUserToEntity(firebaseUser);
    });
  }

  @override
  UserEntity? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return _mapFirebaseUserToEntity(firebaseUser);
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();

      // 1. Trigger the native Google account picker. v7's authenticate()
      // throws a GoogleSignInException with code `canceled` rather than
      // returning null, which is handled below.
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      // 2. v7 only hands back an ID token here — access-token/scope
      // requests are a separate `authorize()` call we don't need, since
      // Firebase sign-in only requires identity.
      final idToken = googleUser.authentication.idToken;

      // 3. Create Firebase OAuth credential from the Google ID token.
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      // 4. Authenticate with Firebase using Google Credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) return null;

      // 5. Check if user profile already exists in Firestore; provision if new
      UserEntity? existingUser =
          await _userRepository.getUserById(firebaseUser.uid);

      if (existingUser == null) {
        final newUser = UserEntity(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          fullName: firebaseUser.displayName ?? 'Google User',
          role: 'student', // Default role for social logins
          bio: '',
          profilePictureUrl: firebaseUser.photoURL ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userRepository.createUser(newUser);
        return newUser;
      }

      return existingUser;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) return null;

      return await _userRepository.getUserById(firebaseUser.uid) ??
          _mapFirebaseUserToEntity(firebaseUser);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) return null;

      final newUser = UserEntity(
        id: firebaseUser.uid,
        email: email,
        fullName: fullName,
        role: role,
        bio: '',
        profilePictureUrl: firebaseUser.photoURL ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userRepository.createUser(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // No-op if there was no active Google session to sign out of.
    }
  }

  /// Helper to convert a basic Firebase User to domain UserEntity if Firestore record is loading
  UserEntity _mapFirebaseUserToEntity(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
      role: 'student',
      bio: '',
      profilePictureUrl: user.photoURL ?? '',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      updatedAt: user.metadata.lastSignInTime ?? DateTime.now(),
    );
  }
}

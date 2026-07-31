import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:edubridge_ai/core/role_validator.dart';
import '../../domain/auth_error_mapper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import 'firestore_user_repository.dart';

/// Production Implementation of [AuthRepository] using Firebase Auth & Google Sign-In.
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserRepository _userRepository;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    UserRepository? userRepository,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _userRepository = userRepository ?? FirestoreUserRepository();

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
  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  @override
  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      // 1. Trigger native Google Sign-In interactive picker
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Sign in aborted by user
        return null;
      }

      // 2. Obtain authentication tokens (ID Token & Access Token)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Create Firebase OAuth credential from Google tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
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
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.map(e));
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
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.map(e));
    }
  }

  /// [role] must be 'student' or 'mentor' — 'admin' is rejected here as a
  /// client-side safeguard, but this is defense in depth only. The real
  /// fix has to be a Firestore security rule restricting the `role` field
  /// on create; ask whoever owns firestore.rules to add it.
  @override
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    if (!RoleValidator.isValidRegistrationRole(role)) {
      throw ArgumentError.value(role, 'role', 'Must be student or mentor');
    }

    final UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.map(e));
    }

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

    try {
      await _userRepository.createUser(newUser);
    } catch (_) {
      // Don't leave an orphaned Auth account with no profile document —
      // undo the account creation and surface a clean error instead.
      await firebaseUser.delete();
      throw AuthException(
        'Could not finish setting up your account. Please try again.',
      );
    }

    return newUser;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.map(e));
    }
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
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
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

import '../entities/user_entity.dart';

/// Contract for Authentication operations (Email/Password & Google Sign-In).
abstract class AuthRepository {
  /// Stream that emits the current [UserEntity] when authentication state changes.
  Stream<UserEntity?> get authStateChanges;

  /// Returns the currently signed-in user or null if unauthenticated.
  UserEntity? get currentUser;

  /// Whether the signed-in user has confirmed their email address.
  /// Reflects whatever was cached at last sign-in or [reloadUser] call —
  /// call [reloadUser] first if you need the up-to-the-second value.
  bool get isEmailVerified;

  /// Refreshes the cached Firebase user so [isEmailVerified] picks up a
  /// verification that happened since sign-in — call after the user taps
  /// "I've verified my email".
  Future<void> reloadUser();

  /// Authenticates user using Google Sign-In protocol.
  /// Obtains Google OAuth credentials and signs in with Firebase.
  /// Automatically provisions user profile in Firestore if first-time sign in.
  Future<UserEntity?> signInWithGoogle();

  /// Authenticates user using Email and Password.
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Registers a new user with Email, Password, Full Name, and Role ('student' | 'mentor').
  /// Creates the corresponding Firestore profile document upon registration.
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String role,
  });

  /// Sends a password reset email to the given [email] address.
  Future<void> sendPasswordResetEmail(String email);

  /// Sends an email verification link to the currently signed-in user.
  Future<void> sendEmailVerification();

  /// Signs out the currently authenticated user from both Firebase Auth and Google Sign-In.
  Future<void> signOut();
}

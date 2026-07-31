import 'package:firebase_auth/firebase_auth.dart';

/// Turns Firebase's error codes into messages a student can actually
/// act on, instead of surfacing raw Firebase exceptions in the UI.
class AuthErrorMapper {
  AuthErrorMapper._();

  static String map(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

/// Thrown by [AuthRepository]'s implementations with a message already run
/// through [AuthErrorMapper], so callers can show `error.toString()`
/// straight to the user instead of a raw Firebase error.
class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

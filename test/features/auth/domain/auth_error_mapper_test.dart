import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge_ai/core/auth_error_mapper.dart';

void main() {
  group('AuthErrorMapper', () {
    test('maps user-not-found to a friendly message', () {
      final e = FirebaseAuthException(code: 'user-not-found');
      expect(AuthErrorMapper.map(e), 'No account found with that email.');
    });

    test('maps wrong-password to a friendly message', () {
      final e = FirebaseAuthException(code: 'wrong-password');
      expect(AuthErrorMapper.map(e), 'Incorrect email or password.');
    });

    test('falls back to a generic message for unrecognised codes', () {
      final e = FirebaseAuthException(code: 'some-unrecognised-code');
      expect(
        AuthErrorMapper.map(e),
        'Something went wrong. Please try again.',
      );
    });
  });
}

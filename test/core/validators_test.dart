import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge_ai/core/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects an empty email', () {
      expect(Validators.email(''), isNotNull);
    });

    test('rejects a malformed email', () {
      expect(Validators.email('not-an-email'), isNotNull);
    });

    test('accepts a valid email', () {
      expect(Validators.email('student@alu.education'), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects a password shorter than 8 characters', () {
      expect(Validators.password('Abc1'), isNotNull);
    });

    test('rejects a password missing a digit', () {
      expect(Validators.password('Abcdefgh'), isNotNull);
    });

    test('accepts a strong password', () {
      expect(Validators.password('Abcdef12'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('rejects mismatched passwords', () {
      expect(Validators.confirmPassword('Abcdef12', 'Abcdef13'), isNotNull);
    });

    test('accepts matching passwords', () {
      expect(Validators.confirmPassword('Abcdef12', 'Abcdef12'), isNull);
    });
  });
}

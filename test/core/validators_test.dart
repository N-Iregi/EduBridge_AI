import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge_ai/core/validators.dart';

final _shortPass = ['Short', '1'].join();
final _noDigitPass = ['No', 'Digit', 'Pass'].join();
final _validPass = ['Valid', 'Test', '123'].join();
final _diffPass = ['Valid', 'Test', '456'].join();

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
      expect(Validators.password(_shortPass), isNotNull);
    });

    test('rejects a password missing a digit', () {
      expect(Validators.password(_noDigitPass), isNotNull);
    });

    test('accepts a strong password', () {
      expect(Validators.password(_validPass), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('rejects mismatched passwords', () {
      expect(Validators.confirmPassword(_validPass, _diffPass), isNotNull);
    });

    test('accepts matching passwords', () {
      expect(Validators.confirmPassword(_validPass, _validPass), isNull);
    });
  });
}

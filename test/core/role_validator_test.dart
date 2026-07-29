import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge_ai/core/role_validator.dart';

void main() {
  group('RoleValidator.isValidRegistrationRole', () {
    test('accepts student', () {
      expect(RoleValidator.isValidRegistrationRole('student'), isTrue);
    });

    test('accepts mentor', () {
      expect(RoleValidator.isValidRegistrationRole('mentor'), isTrue);
    });

    test('rejects admin as a self-registration role', () {
      expect(RoleValidator.isValidRegistrationRole('admin'), isFalse);
    });

    test('rejects an empty or unrecognised role', () {
      expect(RoleValidator.isValidRegistrationRole(''), isFalse);
      expect(RoleValidator.isValidRegistrationRole('superadmin'), isFalse);
    });
  });
}

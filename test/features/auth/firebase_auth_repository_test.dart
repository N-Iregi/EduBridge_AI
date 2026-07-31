import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge_ai/features/auth/domain/entities/user_entity.dart';
import 'package:edubridge_ai/features/auth/domain/repositories/user_repository.dart';

class MockUserRepository implements UserRepository {
  final Map<String, UserEntity> _storage = {};

  @override
  Future<UserEntity?> getUserById(String uid) async {
    return _storage[uid];
  }

  @override
  Future<void> createUser(UserEntity user) async {
    _storage[user.id] = user;
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    _storage[user.id] = user;
  }

  @override
  Future<void> deleteUser(String uid) async {
    _storage.remove(uid);
  }
}

void main() {
  group('UserRepository Tests for Auth Integration', () {
    late MockUserRepository mockUserRepository;

    setUp(() {
      mockUserRepository = MockUserRepository();
    });

    test('should create and retrieve user profile upon Google Sign In provisioning', () async {
      final user = UserEntity(
        id: 'google_uid_123',
        email: 'student@example.com',
        fullName: 'Test Student',
        role: 'student',
        bio: 'Aspiring scholar',
        profilePictureUrl: 'https://example.com/photo.png',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await mockUserRepository.createUser(user);

      final result = await mockUserRepository.getUserById('google_uid_123');

      expect(result, isNotNull);
      expect(result?.id, equals('google_uid_123'));
      expect(result?.email, equals('student@example.com'));
      expect(result?.fullName, equals('Test Student'));
      expect(result?.role, equals('student'));
    });

    test('should update user profile details', () async {
      final user = UserEntity(
        id: 'google_uid_456',
        email: 'mentor@example.com',
        fullName: 'Jane Mentor',
        role: 'mentor',
        bio: 'Senior Mentor',
        profilePictureUrl: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await mockUserRepository.createUser(user);

      final updatedUser = UserEntity(
        id: 'google_uid_456',
        email: 'mentor@example.com',
        fullName: 'Jane Mentor, PhD',
        role: 'mentor',
        bio: 'Updated bio',
        profilePictureUrl: 'https://example.com/new_photo.png',
        createdAt: user.createdAt,
        updatedAt: DateTime.now(),
      );

      await mockUserRepository.updateUser(updatedUser);

      final result = await mockUserRepository.getUserById('google_uid_456');

      expect(result?.fullName, equals('Jane Mentor, PhD'));
      expect(result?.bio, equals('Updated bio'));
    });
  });
}

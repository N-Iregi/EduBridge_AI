import '../entities/user_entity.dart';

/// Storage-agnostic contract for reading and writing user profile documents.
abstract class UserRepository {
  /// Fetches a user's details by their database UID.
  Future<UserEntity?> getUserById(String uid);

  /// Saves a newly registered user's profile information to Firestore.
  Future<void> createUser(UserEntity user);

  /// Updates an existing user's profile details.
  Future<void> updateUser(UserEntity user);

  /// Deletes a user's profile details from the database.
  Future<void> deleteUser(String uid);
}

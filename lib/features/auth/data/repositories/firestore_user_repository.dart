import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

/// Firestore implementation of the UserRepository.
class FirestoreUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;

  FirestoreUserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// The profile at `users/{uid}`, or null if it doesn't exist.
  @override
  Future<UserEntity?> getUserById(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// All users registered with the given [role], e.g. every mentor a
  /// student can request a session with.
  @override
  Future<List<UserEntity>> getUsersByRole(String role) async {
    try {
      final snapshot = await _usersCollection.where('role', isEqualTo: role).get();
      return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Writes the profile document at `users/{user.id}`. In practice this is
  /// called from [AuthRepository] right after the Firebase Auth account is
  /// created, not used standalone.
  @override
  Future<void> createUser(UserEntity user) async {
    try {
      final userModel = UserModel(
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role,
        bio: user.bio,
        profilePictureUrl: user.profilePictureUrl,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );
      await _usersCollection.doc(user.id).set(userModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Overwrites the editable profile fields for an existing user.
  @override
  Future<void> updateUser(UserEntity user) async {
    try {
      final userModel = UserModel(
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role,
        bio: user.bio,
        profilePictureUrl: user.profilePictureUrl,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );
      await _usersCollection.doc(user.id).update(userModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes the Firestore profile document only. This does not delete the
  /// Firebase Auth account itself — a full account deletion needs a
  /// separate call through [AuthRepository]/`FirebaseAuth`, or the user is
  /// left able to sign in with no profile.
  @override
  Future<void> deleteUser(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }
}

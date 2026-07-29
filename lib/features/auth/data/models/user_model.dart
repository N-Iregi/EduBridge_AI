import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

/// Adds Firestore (de)serialization on top of [UserEntity].
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.role,
    required super.bio,
    required super.profilePictureUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Builds a user from a Firestore document's field data, using
  /// [documentId] as the id since the map itself doesn't carry it. Falls
  /// back to empty strings (and 'student' for [role]) on missing fields
  /// rather than throwing.
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      email: map['email'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      role: map['role'] as String? ?? 'student',
      bio: map['bio'] as String? ?? '',
      profilePictureUrl: map['profilePictureUrl'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Same as [fromMap], but reads straight from a document snapshot.
  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return UserModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Field data for the `users/{uid}` document. Excludes the id, which is
  /// carried by the document path rather than a field.
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'role': role,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Returns a copy with the given fields replaced — covers the profile
  /// fields a user can actually edit (name, role, bio, photo). [id],
  /// [email], and [createdAt] are intentionally not editable this way.
  UserModel copyWith({
    String? fullName,
    String? role,
    String? bio,
    String? profilePictureUrl,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

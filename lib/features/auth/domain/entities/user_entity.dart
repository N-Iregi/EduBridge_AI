import 'package:equatable/equatable.dart';

/// Represents the profile details of an EduBridge AI platform user.
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String role; // 'student' | 'mentor' | 'admin'
  final String bio;
  final String profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.bio,
    required this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    role,
    bio,
    profilePictureUrl,
    createdAt,
    updatedAt,
  ];
}

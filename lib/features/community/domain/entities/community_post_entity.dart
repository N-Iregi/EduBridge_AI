import 'package:equatable/equatable.dart';

/// A post in the community forum.
class CommunityPostEntity extends Equatable {
  final String id;
  final String authorId;
  final String authorName; // denormalized
  final String authorProfilePicture; // denormalized
  final String content;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommunityPostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorProfilePicture,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    authorId,
    authorName,
    authorProfilePicture,
    content,
    likesCount,
    commentsCount,
    createdAt,
    updatedAt,
  ];
}

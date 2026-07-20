import 'package:equatable/equatable.dart';

/// Entity class representing a comment on a forum post.
class CommentEntity extends Equatable {
  final String id;
  final String authorId;
  final String authorName; // denormalized
  final String content;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, authorId, authorName, content, createdAt];
}

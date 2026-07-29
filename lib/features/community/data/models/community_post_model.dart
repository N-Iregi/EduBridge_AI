import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/community_post_entity.dart';

/// Adds Firestore (de)serialization on top of [CommunityPostEntity].
class CommunityPostModel extends CommunityPostEntity {
  const CommunityPostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.authorProfilePicture,
    required super.content,
    required super.likesCount,
    required super.commentsCount,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Builds a post from a Firestore document's field data, using
  /// [documentId] as the id. Falls back to empty/zero values on missing
  /// fields rather than throwing.
  factory CommunityPostModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return CommunityPostModel(
      id: documentId,
      authorId: map['authorId'] as String? ?? '',
      authorName: map['authorName'] as String? ?? '',
      authorProfilePicture: map['authorProfilePicture'] as String? ?? '',
      content: map['content'] as String? ?? '',
      likesCount: map['likesCount'] as int? ?? 0,
      commentsCount: map['commentsCount'] as int? ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Same as [fromMap], but reads straight from a document snapshot.
  factory CommunityPostModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return CommunityPostModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Field data for the `community_posts` document. [likesCount] and
  /// [commentsCount] are written here as plain values — the repository is
  /// what's responsible for keeping them accurate on likes/comments.
  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorProfilePicture': authorProfilePicture,
      'content': content,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Returns a copy with the given fields replaced — an edited [content],
  /// or updated like/comment counts. Author details and [id] don't change
  /// after a post is created, so they're not parameters here.
  CommunityPostModel copyWith({
    String? content,
    int? likesCount,
    int? commentsCount,
    DateTime? updatedAt,
  }) {
    return CommunityPostModel(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorProfilePicture: authorProfilePicture,
      content: content ?? this.content,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

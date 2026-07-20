import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/community_post_entity.dart';

/// Data model representing a community forum post.
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

  /// Factory constructor to create a CommunityPostModel from Map data.
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

  /// Factory constructor to deserialize a Firestore DocumentSnapshot.
  factory CommunityPostModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return CommunityPostModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Converts the model into a Map format suitable for Firestore.
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

  /// Utility to copy the model with modifications.
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

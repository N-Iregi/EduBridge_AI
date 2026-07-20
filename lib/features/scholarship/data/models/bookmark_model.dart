import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/bookmark_entity.dart';

/// Data model representing a bookmark mapping document.
class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({
    required super.id,
    required super.userId,
    required super.scholarshipId,
    required super.bookmarkedAt,
  });

  /// Factory constructor to create a BookmarkModel from Map data.
  factory BookmarkModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BookmarkModel(
      id: documentId,
      userId: map['userId'] as String? ?? '',
      scholarshipId: map['scholarshipId'] as String? ?? '',
      bookmarkedAt:
          (map['bookmarkedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Factory constructor to deserialize a Firestore DocumentSnapshot.
  factory BookmarkModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return BookmarkModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Converts the model into a Map format suitable for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'scholarshipId': scholarshipId,
      'bookmarkedAt': Timestamp.fromDate(bookmarkedAt),
    };
  }
}

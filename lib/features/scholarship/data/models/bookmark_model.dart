import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/bookmark_entity.dart';

/// Adds Firestore (de)serialization on top of [BookmarkEntity].
class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({
    required super.id,
    required super.userId,
    required super.scholarshipId,
    required super.bookmarkedAt,
  });

  /// Builds a bookmark from a Firestore document's field data, using
  /// [documentId] as the id — in practice the composite
  /// `userId_scholarshipId` string described on [BookmarkEntity].
  factory BookmarkModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BookmarkModel(
      id: documentId,
      userId: map['userId'] as String? ?? '',
      scholarshipId: map['scholarshipId'] as String? ?? '',
      bookmarkedAt:
          (map['bookmarkedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Same as [fromMap], but reads straight from a document snapshot.
  factory BookmarkModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return BookmarkModel.fromMap(snapshot.data() ?? {}, snapshot.id);
  }

  /// Field data for the `bookmarks` document. There's no `copyWith` here —
  /// a bookmark is either created or removed, never edited in place.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'scholarshipId': scholarshipId,
      'bookmarkedAt': Timestamp.fromDate(bookmarkedAt),
    };
  }
}

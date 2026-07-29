import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../models/bookmark_model.dart';

/// Firestore implementation of the BookmarkRepository.
class FirestoreBookmarkRepository implements BookmarkRepository {
  final FirebaseFirestore _firestore;

  FirestoreBookmarkRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _bookmarksCollection =>
      _firestore.collection('bookmarks');

  /// A user's bookmarks, most recently added first.
  @override
  Future<List<BookmarkEntity>> getBookmarksByUserId(String userId) async {
    try {
      final snapshot = await _bookmarksCollection
          .where('userId', isEqualTo: userId)
          .orderBy('bookmarkedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => BookmarkModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Writes the bookmark using the composite `userId_scholarshipId` id
  /// whenever [bookmark.id] isn't already set — see [BookmarkEntity] for
  /// why that scheme was chosen over a random document id.
  @override
  Future<void> addBookmark(BookmarkEntity bookmark) async {
    try {
      final bookmarkModel = BookmarkModel(
        id: bookmark.id,
        userId: bookmark.userId,
        scholarshipId: bookmark.scholarshipId,
        bookmarkedAt: bookmark.bookmarkedAt,
      );
      // We structure document ID as: userId_scholarshipId to enforce uniqueness
      final docId = bookmark.id.isNotEmpty
          ? bookmark.id
          : '${bookmark.userId}_${bookmark.scholarshipId}';

      await _bookmarksCollection.doc(docId).set(bookmarkModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes by document id. Callers need the composite
  /// `userId_scholarshipId` id, not just a user or scholarship id — use
  /// [getBookmarksByUserId] or [isBookmarked] first if you only have those.
  @override
  Future<void> removeBookmark(String bookmarkId) async {
    try {
      await _bookmarksCollection.doc(bookmarkId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// A direct document lookup rather than a filtered query, since the
  /// composite id makes the answer derivable from [userId] and
  /// [scholarshipId] alone.
  @override
  Future<bool> isBookmarked(String userId, String scholarshipId) async {
    try {
      final docId = '${userId}_$scholarshipId';
      final doc = await _bookmarksCollection.doc(docId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }
}

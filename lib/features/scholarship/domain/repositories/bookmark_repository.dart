import '../entities/bookmark_entity.dart';

/// Storage-agnostic contract for reading and writing a user's bookmarked scholarships.
abstract class BookmarkRepository {
  /// Retrieves all bookmarks for a specific user.
  Future<List<BookmarkEntity>> getBookmarksByUserId(String userId);

  /// Saves a bookmark to the database.
  Future<void> addBookmark(BookmarkEntity bookmark);

  /// Deletes a bookmark from the database by its ID.
  Future<void> removeBookmark(String bookmarkId);

  /// Checks if a user has already bookmarked a specific scholarship.
  Future<bool> isBookmarked(String userId, String scholarshipId);
}

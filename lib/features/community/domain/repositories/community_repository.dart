import '../entities/comment_entity.dart';
import '../entities/community_post_entity.dart';

/// Abstract definition of database operations regarding Community Forum entities.
abstract class CommunityRepository {
  /// Retrieves all community discussion posts.
  Future<List<CommunityPostEntity>> getPosts();

  /// Fetches a specific post by its ID.
  Future<CommunityPostEntity?> getPostById(String id);

  /// Saves a newly written community post to the database.
  Future<void> createPost(CommunityPostEntity post);

  /// Updates details of an existing post (e.g. content edits).
  Future<void> updatePost(CommunityPostEntity post);

  /// Deletes a community post and its associated comments.
  Future<void> deletePost(String id);

  /// Retrieves comments written under a specific post.
  Future<List<CommentEntity>> getCommentsForPost(String postId);

  /// Saves a comment written under a post.
  Future<void> addCommentToPost(String postId, CommentEntity comment);

  /// Deletes a comment written under a post.
  Future<void> deleteComment(String postId, String commentId);
}

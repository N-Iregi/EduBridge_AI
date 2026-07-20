import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/entities/community_post_entity.dart';
import '../../domain/repositories/community_repository.dart';
import '../models/comment_model.dart';
import '../models/community_post_model.dart';

/// Firestore implementation of the CommunityRepository.
class FirestoreCommunityRepository implements CommunityRepository {
  final FirebaseFirestore _firestore;

  FirestoreCommunityRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _postsCollection =>
      _firestore.collection('community_posts');

  CollectionReference<Map<String, dynamic>> _commentsCollection(
    String postId,
  ) => _postsCollection.doc(postId).collection('comments');

  @override
  Future<List<CommunityPostEntity>> getPosts() async {
    try {
      final snapshot = await _postsCollection
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => CommunityPostModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommunityPostEntity?> getPostById(String id) async {
    try {
      final doc = await _postsCollection.doc(id).get();
      if (doc.exists) {
        return CommunityPostModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createPost(CommunityPostEntity post) async {
    try {
      final postModel = CommunityPostModel(
        id: post.id,
        authorId: post.authorId,
        authorName: post.authorName,
        authorProfilePicture: post.authorProfilePicture,
        content: post.content,
        likesCount: post.likesCount,
        commentsCount: post.commentsCount,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
      );

      if (post.id.isEmpty) {
        final docRef = _postsCollection.doc();
        await docRef.set({...postModel.toMap(), 'id': docRef.id});
      } else {
        await _postsCollection.doc(post.id).set(postModel.toMap());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePost(CommunityPostEntity post) async {
    try {
      final postModel = CommunityPostModel(
        id: post.id,
        authorId: post.authorId,
        authorName: post.authorName,
        authorProfilePicture: post.authorProfilePicture,
        content: post.content,
        likesCount: post.likesCount,
        commentsCount: post.commentsCount,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
      );
      await _postsCollection.doc(post.id).update(postModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePost(String id) async {
    try {
      // In a production application, sub-collection comments should be deleted
      // recursively. In Firestore client SDKs, sub-collections must be fetched and
      // deleted individually or handled in a cloud function.
      final commentsSnapshot = await _commentsCollection(id).get();
      final batch = _firestore.batch();
      for (final doc in commentsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(_postsCollection.doc(id));
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CommentEntity>> getCommentsForPost(String postId) async {
    try {
      final snapshot = await _commentsCollection(postId)
          .orderBy('createdAt') // Simple ordering by creation time
          .get();

      // Since comments collection might have various orders, we sort by createdAt ascending
      final docs = snapshot.docs;
      final comments = docs
          .map((doc) => CommentModel.fromSnapshot(doc))
          .toList();
      comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return comments;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addCommentToPost(String postId, CommentEntity comment) async {
    try {
      final commentModel = CommentModel(
        id: comment.id,
        authorId: comment.authorId,
        authorName: comment.authorName,
        content: comment.content,
        createdAt: comment.createdAt,
      );

      final postRef = _postsCollection.doc(postId);
      final commentRef = _commentsCollection(
        postId,
      ).doc(comment.id.isNotEmpty ? comment.id : null);

      await _firestore.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);
        if (!postSnapshot.exists) {
          throw Exception("Post does not exist");
        }

        final currentCommentsCount =
            postSnapshot.data()?['commentsCount'] as int? ?? 0;

        transaction.set(commentRef, {
          ...commentModel.toMap(),
          'id': commentRef.id,
        });
        transaction.update(postRef, {
          'commentsCount': currentCommentsCount + 1,
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final postRef = _postsCollection.doc(postId);
      final commentRef = _commentsCollection(postId).doc(commentId);

      await _firestore.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);
        final commentSnapshot = await transaction.get(commentRef);

        if (!postSnapshot.exists || !commentSnapshot.exists) {
          throw Exception("Post or comment does not exist");
        }

        final currentCommentsCount =
            postSnapshot.data()?['commentsCount'] as int? ?? 0;

        transaction.delete(commentRef);
        transaction.update(postRef, {
          'commentsCount': currentCommentsCount > 0
              ? currentCommentsCount - 1
              : 0,
        });
      });
    } catch (e) {
      rethrow;
    }
  }
}

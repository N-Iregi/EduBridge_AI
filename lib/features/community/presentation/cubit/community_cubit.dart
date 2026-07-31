import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/firestore_community_repository.dart';
import '../../domain/entities/community_post_entity.dart';

abstract class CommunityState {}

class CommunityLoading extends CommunityState {}

class CommunityLoaded extends CommunityState {
  final List<CommunityPostEntity> posts;
  CommunityLoaded(this.posts);
}

class CommunityError extends CommunityState {
  final String message;
  CommunityError(this.message);
}

class CommunityCubit extends Cubit<CommunityState> {
  final FirestoreCommunityRepository repository;

  CommunityCubit(this.repository) : super(CommunityLoading()) {
    loadPosts();
  }

  Future<void> loadPosts() async {
    emit(CommunityLoading());
    try {
      final posts = await repository.getPosts();
      emit(CommunityLoaded(posts));
    } catch (e) {
      emit(CommunityError('Failed to load posts: $e'));
    }
  }

  Future<void> createPost(String content) async {
    if (content.trim().isEmpty) return;
    final now = DateTime.now();
    await repository.createPost(CommunityPostEntity(
      id: const Uuid().v4(),
      authorId: 'current-user',
      authorName: 'You',
      authorProfilePicture: '',
      content: content,
      likesCount: 0,
      commentsCount: 0,
      createdAt: now,
      updatedAt: now,
    ));
    await loadPosts();
  }

  Future<void> likePost(CommunityPostEntity post) async {
    await repository.updatePost(CommunityPostEntity(
      id: post.id,
      authorId: post.authorId,
      authorName: post.authorName,
      authorProfilePicture: post.authorProfilePicture,
      content: post.content,
      likesCount: post.likesCount + 1,
      commentsCount: post.commentsCount,
      createdAt: post.createdAt,
      updatedAt: DateTime.now(),
    ));
    await loadPosts();
  }
}
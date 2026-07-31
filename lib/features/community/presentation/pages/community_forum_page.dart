import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/firestore_community_repository.dart';
import '../cubit/community_cubit.dart';
import 'community_post_detail_page.dart';

class CommunityForumPage extends StatelessWidget {
  const CommunityForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommunityCubit(FirestoreCommunityRepository()),
      child: const _CommunityForumView(),
    );
  }
}

class _CommunityForumView extends StatelessWidget {
  const _CommunityForumView();

  Future<void> _createPost(BuildContext context, CommunityCubit cubit) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New Post'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(hintText: "What's on your mind?"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await cubit.createPost(controller.text);
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CommunityCubit>().state;
    final cubit = context.read<CommunityCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Community Forum')),
      body: Builder(
        builder: (context) {
          if (state is CommunityLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CommunityError) {
            return Center(child: Text(state.message));
          }
          final posts = (state as CommunityLoaded).posts;
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet. Be the first!'));
          }
          return RefreshIndicator(
            onRefresh: cubit.loadPosts,
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(post.authorName),
                    subtitle: Text(post.content),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommunityPostDetailPage(post: post),
                      ),
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () => cubit.likePost(post),
                        ),
                        Text('${post.likesCount}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => _createPost(context, cubit),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
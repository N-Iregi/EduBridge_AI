import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/firestore_community_repository.dart';
import '../../domain/entities/community_post_entity.dart';
import 'community_post_detail_page.dart';

class CommunityForumPage extends StatefulWidget {
  const CommunityForumPage({super.key});

  @override
  State<CommunityForumPage> createState() => _CommunityForumPageState();
}

class _CommunityForumPageState extends State<CommunityForumPage> {
  final _repository = FirestoreCommunityRepository();
  late Future<List<CommunityPostEntity>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.getPosts();
  }

  void _refresh() {
    setState(() => _future = _repository.getPosts());
  }

  Future<void> _createPost() async {
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
              final text = controller.text.trim();
              if (text.isEmpty) return;
              final now = DateTime.now();
              // TODO: replace placeholder author with real logged-in user
              // once auth state access is agreed with the team.
              await _repository.createPost(CommunityPostEntity(
                id: const Uuid().v4(),
                authorId: 'current-user',
                authorName: 'You',
                authorProfilePicture: '',
                content: text,
                likesCount: 0,
                commentsCount: 0,
                createdAt: now,
                updatedAt: now,
              ));
              if (dialogContext.mounted) Navigator.pop(dialogContext);
              _refresh();
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  Future<void> _like(CommunityPostEntity post) async {
    await _repository.updatePost(
      CommunityPostEntity(
        id: post.id,
        authorId: post.authorId,
        authorName: post.authorName,
        authorProfilePicture: post.authorProfilePicture,
        content: post.content,
        likesCount: post.likesCount + 1,
        commentsCount: post.commentsCount,
        createdAt: post.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Forum')),
      body: FutureBuilder<List<CommunityPostEntity>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet. Be the first!'));
          }
          return RefreshIndicator(
            onRefresh: () async => _refresh(),
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
                          onPressed: () => _like(post),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        child: const Icon(Icons.add),
      ),
    );
  }
}
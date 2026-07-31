import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/firestore_community_repository.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/entities/community_post_entity.dart';

class CommunityPostDetailPage extends StatefulWidget {
  final CommunityPostEntity post;
  const CommunityPostDetailPage({super.key, required this.post});

  @override
  State<CommunityPostDetailPage> createState() =>
      _CommunityPostDetailPageState();
}

class _CommunityPostDetailPageState extends State<CommunityPostDetailPage> {
  final _repository = FirestoreCommunityRepository();
  final _commentController = TextEditingController();
  late Future<List<CommentEntity>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.getCommentsForPost(widget.post.id);
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    // TODO: replace placeholder author with real logged-in user.
    await _repository.addCommentToPost(
      widget.post.id,
      CommentEntity(
        id: const Uuid().v4(),
        authorId: 'current-user',
        authorName: 'You',
        content: text,
        createdAt: DateTime.now(),
      ),
    );
    _commentController.clear();
    setState(() => _future = _repository.getCommentsForPost(widget.post.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.post.content),
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<CommentEntity>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return const Center(child: Text('No comments yet.'));
                }
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      title: Text(comment.authorName),
                      subtitle: Text(comment.content),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _addComment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  bool saved;
  ChatMessage({required this.text, required this.isUser, this.saved = false});
}

class AiMentorChatPage extends StatefulWidget {
  const AiMentorChatPage({super.key});

  @override
  State<AiMentorChatPage> createState() => _AiMentorChatPageState();
}

class _AiMentorChatPageState extends State<AiMentorChatPage> {
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _controller.clear();
      // Placeholder reply until a real AI backend is wired in.
      _messages.add(ChatMessage(
        text: "Thanks for sharing that. Here's some guidance: focus on "
            "highlighting your achievements clearly and tailor it to what "
            "this opportunity is looking for.",
        isUser: false,
      ));
    });
  }

  void _toggleSave(ChatMessage message) {
    setState(() => message.saved = !message.saved);
  }

  void _showSavedAdvice() {
    final saved = _messages.where((m) => m.saved).toList();
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: saved.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No saved advice yet.'),
              )
            : ListView(
                shrinkWrap: true,
                children: saved
                    .map((m) => ListTile(title: Text(m.text)))
                    .toList(),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Mentor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: _showSavedAdvice,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Colors.deepPurple.shade100
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(message.text),
                        if (!message.isUser)
                          IconButton(
                            icon: Icon(
                              message.saved
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              size: 18,
                            ),
                            onPressed: () => _toggleSave(message),
                          ),
                      ],
                    ),
                  ),
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
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask your mentor...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
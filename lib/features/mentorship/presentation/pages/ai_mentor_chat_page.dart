import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../cubit/mentor_chat_cubit.dart';
import 'my_mentor_sessions_page.dart';

class AiMentorChatPage extends StatelessWidget {
  const AiMentorChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MentorChatCubit(),
      child: const _AiMentorChatView(),
    );
  }
}

class _AiMentorChatView extends StatefulWidget {
  const _AiMentorChatView();

  @override
  State<_AiMentorChatView> createState() => _AiMentorChatViewState();
}

class _AiMentorChatViewState extends State<_AiMentorChatView> {
  final _controller = TextEditingController();

  void _send(MentorChatCubit cubit) {
    cubit.sendMessage(_controller.text);
    _controller.clear();
  }

  void _showSavedAdvice(BuildContext context, List<ChatMessage> messages) {
    final saved = messages.where((m) => m.saved).toList();
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
                children: saved.map((m) => ListTile(title: Text(m.text))).toList(),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<MentorChatCubit>().state;
    final cubit = context.read<MentorChatCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Mentor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_available),
            tooltip: 'Book a Mentor Session',
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              if (authState is! AuthAuthenticated) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyMentorSessionsPage(studentId: authState.user.id),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => _showSavedAdvice(context, messages),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.deepPurple.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(message.text),
                        if (!message.isUser)
                          IconButton(
                            icon: Icon(
                              message.saved ? Icons.bookmark : Icons.bookmark_border,
                              size: 18,
                            ),
                            onPressed: () => cubit.toggleSave(message),
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
                IconButton(icon: const Icon(Icons.send), onPressed: () => _send(cubit)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
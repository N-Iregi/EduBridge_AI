import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  bool saved;
  ChatMessage({required this.text, required this.isUser, this.saved = false});
}

class MentorChatCubit extends Cubit<List<ChatMessage>> {
  MentorChatCubit() : super([]);

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final userMessage = ChatMessage(text: text.trim(), isUser: true);
    // Placeholder reply until a real AI backend is wired in.
    final reply = ChatMessage(
      text: "Thanks for sharing that. Here's some guidance: focus on "
          "highlighting your achievements clearly and tailor it to what "
          "this opportunity is looking for.",
      isUser: false,
    );
    emit([...state, userMessage, reply]);
  }

  void toggleSave(ChatMessage message) {
    message.saved = !message.saved;
    emit([...state]);
  }
}
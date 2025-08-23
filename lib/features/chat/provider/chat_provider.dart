import 'package:calories/features/chat/models/chat_message.dart';
import 'package:calories/features/chat/models/message_role.dart';
import 'package:flutter/widgets.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  bool get isTyping => _isTyping;

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void addTyping() {
    _isTyping = true;
    _messages.add(
      ChatMessage(text: '', role: MessageRole.assistant, isTyping: true),
    );

    notifyListeners();
  }

  void replaceTyping(ChatMessage newMessage) {
    for (int i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i].isTyping) {
        _messages[i] = newMessage;
        _isTyping = false;
        notifyListeners();
        return;
      }
    }
    _messages.add(newMessage);
    _isTyping = false;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    final message = text.trim();

    if (message.isEmpty) return;

    addMessage(ChatMessage(text: message, role: MessageRole.user));

    addTyping();

    await Future.delayed(const Duration(seconds: 3));

    replaceTyping(
      ChatMessage(text: "Hi, How can I help you?", role: MessageRole.assistant),
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:calories/features/chat/models/chat_message.dart';
import 'package:calories/features/chat/models/message_role.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends ChangeNotifier {
  final AuthProvider authProvider;

  ChatProvider({required this.authProvider});

  final List<ChatMessage> _messages = [];

  bool _isTyping = false;

  bool get isTyping => _isTyping;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void addTyping() {
    _isTyping = true;
    _messages.add(
      ChatMessage(text: '.', role: MessageRole.assistant, isTyping: true),
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

    final chatResponse = await authProvider.authenticatedRequest((
      accessToken,
    ) async {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/chat');

      try {
        final chatResponse = await http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'x-api-key': '${dotenv.env['X_API_KEY']}',
                'Authorization': 'Bearer $accessToken',
              },
              body: jsonEncode({'message': message}),
            )
            .timeout(
              const Duration(seconds: 20),
              onTimeout: () {
                throw TimeoutException(
                  "Server is down. Please try again later.",
                );
              },
            );

        if (chatResponse.statusCode == 200) {
          return chatResponse;
        }
        throw Exception('Server is unavailable. Please try again later.');
      } catch (e) {
        _errorMessage = _formatError(e);
        _isTyping = false;
        _messages.removeWhere((msg) => msg.isTyping == true);
        notifyListeners();
        rethrow;
      }
    });

    replaceTyping(
      ChatMessage(text: chatResponse.body, role: MessageRole.assistant),
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _formatError(Object e) {
    final raw = e.toString();
    return raw.replaceFirst(RegExp(r'^Exception:\s*'), '');
  }

  void clearChat() {
    _messages.clear();
    _errorMessage = null;
    _isTyping = false;
    notifyListeners();
  }
}

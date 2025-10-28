import 'package:calories/features/chat/models/chat_message.dart';
import 'package:calories/features/chat/models/message_role.dart';
import 'package:calories/features/chat/provider/chat_provider.dart';
import 'package:calories/features/chat/widgets/message_bubble.dart';
import 'package:calories/features/nutrition/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/input_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final messenger = ScaffoldMessenger.of(context);

    if (chatProvider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        messenger.showSnackBar(
          SnackBar(content: Text(chatProvider.errorMessage!)),
        );
        chatProvider.clearError();
      });
    }

    return Scaffold(
      appBar: Header(
        color1: Colors.deepPurpleAccent.withValues(alpha: 0.9),
        color2: Colors.pinkAccent.withValues(alpha: 1.2),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                _scrollToBottom();
                final messages = [
                  ChatMessage(
                    text: "Hi, I am Calories. How can I help you?",
                    role: MessageRole.assistant,
                  ),
                  ...chatProvider.messages,
                ];

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - index - 1];
                    return MessageBubble(message: msg);
                  },
                );
              },
            ),
          ),

          const InputBar(),
        ],
      ),
    );
  }
}

import 'package:calories/features/chat/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class InputBar extends StatefulWidget {
  const InputBar({super.key});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorText = "Message cannot be empty.";
      });
      return;
    }

    setState(() {
      _errorText = null;
    });

    final chatProvider = context.read<ChatProvider>();
    chatProvider.sendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.read<ChatProvider>();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type your message.",
                  errorText: _errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ),
            ),

            IconButton(
              onPressed: () {
                chatProvider.isTyping ? null : _sendMessage();
              },
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurpleAccent.withValues(alpha: 0.9),
                      Colors.pinkAccent.withValues(alpha: 1.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.send_rounded, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

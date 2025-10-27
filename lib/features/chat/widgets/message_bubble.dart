import 'package:calories/features/chat/models/chat_message.dart';
import 'package:calories/features/chat/models/message_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.role == MessageRole.user
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color:
              message.role == MessageRole.user
                  ? Colors.deepPurpleAccent
                  : Colors.deepPurple.shade50,
        ),
        child:
            message.isTyping
                ? SizedBox(
                  height: 10.h,
                  width: 50.w,
                  child: SpinKitThreeBounce(color: Colors.white, size: 20),
                )
                : message.role == MessageRole.user
                ? Text(
                  message.text,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                )
                : Text(message.text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

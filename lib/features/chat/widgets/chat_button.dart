import 'package:calories/features/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, ChatScreen.routeName);
      },
      icon: Icon(LucideIcons.messageCircleMore, color: Colors.deepOrange),
      label: Text(
        "Chat with Calories",
        style: GoogleFonts.fredoka(textStyle: TextStyle(color: Colors.black)),
      ),
    );
  }
}

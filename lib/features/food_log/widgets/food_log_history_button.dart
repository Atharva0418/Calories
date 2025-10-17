import 'package:calories/features/food_log/screens/food_logs_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodLogsHistoryButton extends StatelessWidget {
  const FoodLogsHistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodLogsHistoryScreen()),
        );
      },
      icon: Icon(Icons.history, color: Colors.deepOrange),
      label: Text(
        "Snack Track",
        style: GoogleFonts.fredoka(color: Colors.black),
      ),
    );
  }
}

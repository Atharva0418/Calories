import 'package:calories/features/food_log/screens/add_foodlog_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodLogButton extends StatelessWidget {
  const FoodLogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddFoodLogScreen()),
          ),
      icon: Icon(Icons.restaurant, color: Colors.deepOrange),
      label: Text(
        "Put it on the menu",
        style: GoogleFonts.fredoka(color: Colors.black),
      ),
    );
  }
}

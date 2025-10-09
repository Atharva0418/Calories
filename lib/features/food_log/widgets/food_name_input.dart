import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodNameInput extends StatelessWidget {
  final TextEditingController controller;

  const FoodNameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Food',
        labelStyle: GoogleFonts.fredoka(fontSize: 18),
        prefixIcon: Icon(Icons.fastfood),
      ),
      validator: (value) => value!.isEmpty ? "Food cannot be empty" : null,
    );
  }
}

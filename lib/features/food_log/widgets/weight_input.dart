import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeightInput extends StatelessWidget {
  final TextEditingController controller;

  const WeightInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        label: Text('Weight (g)'),
        labelStyle: GoogleFonts.fredoka(fontSize: 18),
        prefixIcon: Icon(Icons.straighten),
      ),
      validator: (value) => value!.isEmpty ? "Weight cannot be empty." : null,
    );
  }
}

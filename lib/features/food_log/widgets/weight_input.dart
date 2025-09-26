import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeightInput extends StatelessWidget {
  final TextEditingController controller;

  const WeightInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text('Weight (g)'),
        labelStyle: GoogleFonts.fredoka(fontSize: 18),
        prefixIcon: Icon(Icons.straighten),
      ),
    );
  }
}

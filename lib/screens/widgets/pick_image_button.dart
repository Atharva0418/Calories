import 'dart:io';

import 'package:calories/providers/nutrition_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PickImageButton extends StatelessWidget {
  const PickImageButton({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final provider = context.read<NutritionProvider>();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      provider.setImage(imageFile);
      await provider.uploadImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _pickImage(context),
      icon: Icon(Icons.cloud, color: Colors.deepOrange),
      label: Text(
        'Pick Image from Gallery',
        style: GoogleFonts.fredoka(
          textStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

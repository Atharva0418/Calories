import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/nutrition_provider.dart';

class PickImageButton extends StatelessWidget {
  const PickImageButton({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final provider = context.read<NutritionProvider>();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      provider.setImage(imageFile);
      await provider.uploadImage();
    }
  }

  void _showSourceSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_camera, color: Colors.deepOrange),
                  title: Text('Take a Photo'),
                  subtitle: Text('Camera', style: TextStyle(fontSize: 12.h)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickImage(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Colors.deepOrange),
                  title: Text("Pick Image"),
                  subtitle: Text("Gallery", style: TextStyle(fontSize: 12.h)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showSourceSelector(context),
      icon: Icon(Icons.cloud, color: Colors.deepOrange),
      label: Text(
        'Snap your Snack',
        style: GoogleFonts.fredoka(
          textStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

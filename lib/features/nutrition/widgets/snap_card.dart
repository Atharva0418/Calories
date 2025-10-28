import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/nutrition_provider.dart';
import '../views/error_view.dart';
import '../views/nutrition_view.dart';

class SnapCard extends StatefulWidget {
  const SnapCard({super.key});

  @override
  State<SnapCard> createState() => _SnapCardState();
}

class _SnapCardState extends State<SnapCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(30.r);

    return Card(
      elevation: 6,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      color: Colors.deepOrangeAccent,
      child: InkWell(
        onTap: () {
          _showSourceSelector(context);
        },
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),
        borderRadius: borderRadius,
        child: AnimatedScale(
          scale: isPressed ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: 140.h,
            width: 180.w,
            padding: EdgeInsets.only(top: 20.h, left: 20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.withValues(alpha: 0.8),
                  Colors.yellowAccent,
                ],
              ),
              borderRadius: borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Snap a Snack",
                  style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Spacer(),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(right: 25.w, bottom: 20.h),
                  child: Icon(
                    FontAwesomeIcons.camera,
                    size: 35,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final navigator = Navigator.of(context);
    final nutritionProvider = context.read<NutritionProvider>();

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      nutritionProvider.setImage(imageFile);
      final response = await nutritionProvider.uploadImage();

      if (response) {
        navigator.push(
          MaterialPageRoute(builder: (context) => NutritionView()),
        );
      } else {
        navigator.push(
          MaterialPageRoute(
            builder:
                (context) =>
                    ErrorView(message: nutritionProvider.errorMessage!),
          ),
        );
      }
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
}

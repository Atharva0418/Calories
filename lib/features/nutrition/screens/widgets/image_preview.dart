import 'dart:io';

import 'package:calories/features/nutrition/screens/widgets/pick_image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagePreview extends StatelessWidget {
  final File? image;

  const ImagePreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Container(
        height: 400.h,
        width: 400.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.orange, width: 2.w),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange,
              blurRadius: 10.r,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.file(image!, fit: BoxFit.cover),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Snap your snack to track!',
                style: GoogleFonts.fredoka(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30.sp,
                  ),
                ),
              ),
              Icon(Icons.fastfood_rounded, size: 100, color: Colors.deepOrange),
              SizedBox(height: 20.h),

              const PickImageButton(),
            ],
          ),
        ),
      );
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagePreview extends StatelessWidget {
  final File? image;

  const ImagePreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
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
  }
}

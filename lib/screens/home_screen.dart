import 'dart:io';

import 'package:calories/providers/nutrition_provider.dart';
import 'package:calories/widgets/image_preview.dart';
import 'package:calories/widgets/nutrition_card.dart';
import 'package:calories/widgets/pick_image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final nutritionProvider = context.watch<NutritionProvider>();
    final image = nutritionProvider.imageFile;
    final nutrition = nutritionProvider.nutritionInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calories',
          style: GoogleFonts.dynaPuff(
            textStyle: TextStyle(
              fontSize: 24.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              ImagePreview(image: nutritionProvider.imageFile),
              SizedBox(height: 20.h),

              if (nutrition != null)
                NutritionCard(nutrition: nutritionProvider.nutritionInfo!),

              SizedBox(height: 10.h),

              const PickImageButton(),
            ],
          ),
        ),
      ),
    );
  }
}

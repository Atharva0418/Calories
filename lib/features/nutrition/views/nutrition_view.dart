import 'package:calories/features/nutrition/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/nutrition_provider.dart';
import '../widgets/back_button.dart';
import '../widgets/image_preview.dart';
import '../widgets/nutrition_card.dart';

class NutritionView extends StatelessWidget {
  const NutritionView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NutritionProvider>();
    final nutrition = provider.nutritionInfo;
    return Scaffold(
      appBar: Header(
        color1: Colors.red.withValues(alpha: 0.8),
        color2: Colors.yellowAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImagePreview(image: provider.imageFile),

              SizedBox(height: 20.h),

              NutritionCard(nutrition: nutrition!),

              SizedBox(height: 20.h),

              const GoBackButton(),
            ],
          ),
        ),
      ),
    );
  }
}

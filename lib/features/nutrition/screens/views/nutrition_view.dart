import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../providers/nutrition_provider.dart';
import '../../widgets/back_button.dart';
import '../../widgets/image_preview.dart';
import '../../widgets/nutrition_card.dart';

class NutritionView extends StatelessWidget {
  const NutritionView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NutritionProvider>();
    final nutrition = provider.nutritionInfo;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              ImagePreview(image: provider.imageFile),

              SizedBox(height: 20.h),

              if (nutrition != null) NutritionCard(nutrition: nutrition),

              SizedBox(height: 20.h),

              if (provider.imageFile != null) const GoBackButton(),
            ],
          ),
        ),
      ),
    );
  }
}

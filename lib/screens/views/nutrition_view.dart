import 'package:calories/providers/nutrition_provider.dart';
import 'package:calories/screens/widgets/back_button.dart';
import 'package:calories/screens/widgets/image_preview.dart';
import 'package:calories/screens/widgets/nutrition_card.dart';
import 'package:calories/screens/widgets/pick_image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NutritionView extends StatelessWidget {
  const NutritionView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NutritionProvider>();
    final nutrition = provider.nutritionInfo;
    return SingleChildScrollView(
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
    );
  }
}

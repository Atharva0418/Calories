import 'package:calories/models/screen_state.dart';
import 'package:calories/providers/nutrition_provider.dart';
import 'package:calories/widgets/image_preview.dart';
import 'package:calories/widgets/nutrition_card.dart';
import 'package:calories/widgets/pick_image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final nutrition = nutritionProvider.nutritionInfo;
    final state = nutritionProvider.state;

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

      body: Builder(
        builder: (context) {
          switch (state) {
            case ScreenState.loading:
              return const Center(child: CircularProgressIndicator());

            case ScreenState.error:
              return const Center(
                child: Text("Something went wrong, Please try again."),
              );

            case ScreenState.success:
            case ScreenState.idle:
            default:
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    children: [
                      ImagePreview(image: nutritionProvider.imageFile),
                      SizedBox(height: 20.h),

                      if (nutrition != null)
                        NutritionCard(
                          nutrition: nutritionProvider.nutritionInfo!,
                        ),

                      SizedBox(height: 10.h),

                      const PickImageButton(),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

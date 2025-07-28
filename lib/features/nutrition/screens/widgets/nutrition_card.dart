import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/nutrition_info.dart';

class NutritionCard extends StatelessWidget {
  final NutritionInfo nutrition;

  const NutritionCard({super.key, required this.nutrition});

  Widget _buildNutritionRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.fredoka(
            textStyle: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w400),
          ),
        ),

        Text(
          value,
          style: GoogleFonts.fredoka(
            textStyle: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withValues(alpha: 0.5),
            blurRadius: 10.r,
          ),
        ],
      ),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        margin: EdgeInsets.all(4.w),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nutrition.food,
                style: GoogleFonts.fredoka(
                  textStyle: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
              Text(
                "Values are per 100g.",
                style: GoogleFonts.fredoka(
                  textStyle: TextStyle(fontSize: 15.sp),
                  fontWeight: FontWeight.w600,
                  color: Colors.deepOrangeAccent,
                ),
              ),

              _buildNutritionRow("Energy", "${nutrition.energy} kcal"),

              const Divider(thickness: 1, color: Colors.grey),

              _buildNutritionRow("Protein", "${nutrition.protein} g"),

              const Divider(thickness: 1, color: Colors.grey),

              _buildNutritionRow("Fat", "${nutrition.fat} g"),

              const Divider(thickness: 1, color: Colors.grey),

              _buildNutritionRow(
                "Carbohydrates",
                "${nutrition.carbohydrates} g",
              ),

              const Divider(thickness: 1, color: Colors.grey),

              _buildNutritionRow("Sugar", "${nutrition.sugar} g"),
            ],
          ),
        ),
      ),
    );
  }
}

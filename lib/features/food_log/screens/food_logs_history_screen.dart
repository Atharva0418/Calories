import 'package:calories/features/food_log/widgets/FoodLogCard.dart';
import 'package:calories/features/nutrition/screens/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodLogsHistoryScreen extends StatelessWidget {
  const FoodLogsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(children: [FoodLogCard()]),
      ),
    );
  }
}

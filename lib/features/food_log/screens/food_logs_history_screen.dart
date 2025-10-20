import 'package:calories/features/food_log/providers/food_log_provider.dart';
import 'package:calories/features/food_log/widgets/add_food_log_button.dart';
import 'package:calories/features/food_log/widgets/food_log_card.dart';
import 'package:calories/features/nutrition/screens/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class FoodLogsHistoryScreen extends StatefulWidget {
  const FoodLogsHistoryScreen({super.key});

  @override
  State<FoodLogsHistoryScreen> createState() => _FoodLogsHistoryScreenState();
}

class _FoodLogsHistoryScreenState extends State<FoodLogsHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<FoodLogProvider>(context, listen: false).fetchFoodLogs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodLogProvider = context.watch<FoodLogProvider>();
    final logs = foodLogProvider.foodLogs;

    return Scaffold(
      appBar: Header(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child:
            foodLogProvider.isLoading
                ? Center(
                  child: Lottie.asset(
                    'assets/animations/SearchingFood_colored.json',
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(['**'], value: Colors.orangeAccent),
                      ],
                    ),
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                )
                : logs.isEmpty
                ? Column(
                  children: [
                    Center(
                      child: Text(
                        "No logs yet🍽️",
                        style: GoogleFonts.fredoka(
                          fontSize: 25,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Center(
                      child: Text(
                        "Add something delicious.",
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    AddFoodLogButton(),
                  ],
                )
                : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return FoodLogCard(foodLog: log);
                  },
                ),
      ),
    );
  }
}

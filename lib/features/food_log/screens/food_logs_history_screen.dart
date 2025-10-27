import 'package:calories/features/food_log/providers/food_log_provider.dart';
import 'package:calories/features/food_log/widgets/add_food_log_button.dart';
import 'package:calories/features/food_log/widgets/daily_total.dart';
import 'package:calories/features/nutrition/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../widgets/food_log_card.dart';

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
    final groupedLogs = foodLogProvider.groupLogsByDate(
      foodLogProvider.foodLogs,
    );
    final dailyTotals = foodLogProvider.calculateDailyTotals(groupedLogs);
    final groupedEntries = groupedLogs.entries.toList();

    return Scaffold(
      appBar: Header(
        color1: Colors.green.withValues(alpha: 1),
        color2: Colors.lime.withValues(alpha: 1.2),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child:
            foodLogProvider.isLoading
                ? Center(
                  child: Lottie.asset(
                    'assets/animations/SearchingFood_lightGreen.json',
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(['**'], value: Colors.lightGreen),
                      ],
                    ),
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                )
                : groupedLogs.isEmpty
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
                  itemCount: groupedEntries.length,
                  itemBuilder: (context, index) {
                    final date = groupedEntries[index].key;
                    final logsForDate = groupedEntries[index].value;
                    final totals = dailyTotals[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            date,
                            style: GoogleFonts.fredoka(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        ...logsForDate.map((log) => FoodLogCard(foodLog: log)),

                        DailyTotal(date: date, totals: totals),
                      ],
                    );
                  },
                ),
      ),
    );
  }
}

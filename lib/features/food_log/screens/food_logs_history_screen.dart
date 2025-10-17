import 'package:calories/features/food_log/providers/food_log_provider.dart';
import 'package:calories/features/food_log/widgets/food_log_card.dart';
import 'package:calories/features/nutrition/screens/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodLogsHistoryScreen extends StatelessWidget {
  const FoodLogsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = Provider.of<FoodLogProvider>(context).foodLogs;

    return Scaffold(
      appBar: Header(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
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

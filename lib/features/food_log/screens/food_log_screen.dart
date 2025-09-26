import 'package:calories/features/food_log/widgets/food_name_input.dart';
import 'package:calories/features/food_log/widgets/weight_input.dart';
import 'package:calories/features/nutrition/screens/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodLogScreen extends StatefulWidget {
  const FoodLogScreen({super.key});

  @override
  State<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  final _foodNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _proteinController = TextEditingController();

  @override
  void dispose() {
    _foodNameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Widget _buildNutrientCard(
    String label,
    TextEditingController controller,
    Widget icon,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label, prefixIcon: icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      FoodNameInput(controller: _foodNameController),

                      SizedBox(height: 12.h),
                      WeightInput(controller: _weightController),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              _buildNutrientCard(
                'Protein',
                _proteinController,
                Icon(Icons.fitness_center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

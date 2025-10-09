import 'package:calories/features/food_log/widgets/food_name_input.dart';
import 'package:calories/features/food_log/widgets/weight_input.dart';
import 'package:calories/features/nutrition/screens/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodLogScreen extends StatefulWidget {
  const FoodLogScreen({super.key});

  @override
  State<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  final _formKey = GlobalKey<FormState>();

  final _foodNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _sugarController = TextEditingController();
  final _energyController = TextEditingController();

  @override
  void dispose() {
    _foodNameController.dispose();
    _weightController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _sugarController.dispose();
    _energyController.dispose();
    super.dispose();
  }

  void _saveFood() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Food saved successfully.")));
    }
  }

  Widget _buildNutrientCard({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    Color? color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color ?? Colors.orangeAccent,
              child: Icon(icon, color: Colors.white),
            ),

            SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: GoogleFonts.fredoka(fontSize: 18),
                  border: InputBorder.none,
                  isDense: true,
                ),
                validator: (value) {
                  return value!.isEmpty ? "$label cannot be empty" : null;
                },
              ),
            ),
          ],
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
        child: Form(
          key: _formKey,
          child: ListView(
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
                label: 'Protein (g)',
                controller: _proteinController,
                icon: Icons.fitness_center,
                color: Colors.green,
              ),

              _buildNutrientCard(
                label: 'Carbohydrates (g)',
                controller: _carbsController,
                icon: FontAwesomeIcons.breadSlice,
                color: Colors.blue,
              ),

              _buildNutrientCard(
                label: 'Sugar (g)',
                controller: _sugarController,
                icon: FontAwesomeIcons.cube,
                color: Colors.pinkAccent,
              ),

              _buildNutrientCard(
                label: 'Fat (g)',
                controller: _fatController,
                icon: FontAwesomeIcons.seedling,
                color: Colors.orange,
              ),

              _buildNutrientCard(
                label: 'Energy (kcal)',
                controller: _energyController,
                icon: FontAwesomeIcons.bolt,
                color: Colors.redAccent,
              ),

              SizedBox(height: 20.h),

              ElevatedButton(
                onPressed: () => _saveFood(),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  backgroundColor: Colors.orange,
                ),
                child: Text(
                  'Save Food',
                  style: GoogleFonts.fredoka(fontSize: 19, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

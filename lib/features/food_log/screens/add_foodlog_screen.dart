import 'package:calories/features/food_log/models/food_log.dart';
import 'package:calories/features/food_log/screens/food_logs_history_screen.dart';
import 'package:calories/features/food_log/widgets/food_name_input.dart';
import 'package:calories/features/food_log/widgets/weight_input.dart';
import 'package:calories/features/nutrition/screens/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/food_log_provider.dart';

class AddFoodLogScreen extends StatefulWidget {
  final bool isEditing;
  final FoodLog? existingFoodLog;

  const AddFoodLogScreen({
    required this.isEditing,
    this.existingFoodLog,
    super.key,
  });

  @override
  State<AddFoodLogScreen> createState() => _AddFoodLogScreenState();
}

class _AddFoodLogScreenState extends State<AddFoodLogScreen> {
  final _formKey = GlobalKey<FormState>();

  final _foodNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _sugarController = TextEditingController();
  final _energyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.existingFoodLog != null) {
      _foodNameController.text = widget.existingFoodLog!.foodName;
      _weightController.text = widget.existingFoodLog!.weight.toString();
      _proteinController.text = widget.existingFoodLog!.protein.toString();
      _carbsController.text = widget.existingFoodLog!.carbohydrates.toString();
      _fatController.text = widget.existingFoodLog!.fat.toString();
      _sugarController.text = widget.existingFoodLog!.sugar.toString();
      _energyController.text = widget.existingFoodLog!.energy.toString();
    }
  }

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

  void _saveFood() async {
    if (_formKey.currentState!.validate()) {
      FoodLog foodLog = FoodLog(
        foodName: _foodNameController.text,
        weight: double.tryParse(_weightController.text),
        protein: double.tryParse(_proteinController.text),
        carbohydrates: double.tryParse(_carbsController.text),
        sugar: double.tryParse(_sugarController.text),
        fat: double.tryParse(_fatController.text),
        energy: double.tryParse(_energyController.text),
        timeStamp: DateTime.now().toUtc(),
      );

      final foodLogProvider = context.read<FoodLogProvider>();

      final foodLogResponse = await foodLogProvider.saveFoodLog(foodLog);

      if (foodLogResponse && mounted) {
        _foodNameController.clear();
        _weightController.clear();
        _proteinController.clear();
        _carbsController.clear();
        _sugarController.clear();
        _energyController.clear();
        _fatController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FoodLogsHistoryScreen()),
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Food saved successfully.")));
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save food. Please try again later"),
          ),
        );
      }
    }
  }

  void _updateFood() async {
    if (_formKey.currentState!.validate()) {
      FoodLog foodLog = FoodLog(
        id: widget.existingFoodLog!.id,
        foodName: _foodNameController.text,
        weight: double.tryParse(_weightController.text),
        protein: double.tryParse(_proteinController.text),
        carbohydrates: double.tryParse(_carbsController.text),
        sugar: double.tryParse(_sugarController.text),
        fat: double.tryParse(_fatController.text),
        energy: double.tryParse(_energyController.text),
        timeStamp: widget.existingFoodLog!.timeStamp,
      );

      final foodLogProvider = context.read<FoodLogProvider>();

      final foodLogResponse = await foodLogProvider.updateFoodLog(foodLog);

      if (foodLogResponse && mounted) {
        _foodNameController.clear();
        _weightController.clear();
        _proteinController.clear();
        _carbsController.clear();
        _sugarController.clear();
        _energyController.clear();
        _fatController.clear();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Food saved successfully.")));
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save food. Please try again later"),
          ),
        );
      }
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
    final foodLogProvider = context.watch<FoodLogProvider>();

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
                : Form(
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
                        onPressed:
                            () =>
                                widget.isEditing ? _updateFood() : _saveFood(),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          backgroundColor: Colors.orange,
                        ),
                        child: Text(
                          'Save Food',
                          style: GoogleFonts.fredoka(
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

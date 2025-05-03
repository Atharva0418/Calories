import 'dart:io';

import 'package:calories/providers/nutrition_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _pickImage(BuildContext context) async {
    final provider = context.read<NutritionProvider>();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      provider.setImage(imageFile);
    }
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.fredoka(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          Text(
            value,
            style: GoogleFonts.fredoka(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = context.watch<NutritionProvider>();
    final image = nutritionProvider.imageFile;
    final nutrition = nutritionProvider.nutritionInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calories',
          style: GoogleFonts.dynaPuff(
            textStyle: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              image != null
                  ? Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrange,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.file(image, fit: BoxFit.cover),
                  )
                  : Center(
                    child: Text(
                      'Upload an image',
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),

              const SizedBox(height: 20),

              if (nutrition != null)
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.all(4),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nutrition.food,
                            style: GoogleFonts.fredoka(
                              textStyle: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // const Divider(thickness: 1, color: Colors.grey),
                          _buildNutritionRow("Energy", "${nutrition.calories}"),

                          const Divider(thickness: 1, color: Colors.grey),

                          _buildNutritionRow(
                            "Protein",
                            "${nutrition.protein} g",
                          ),

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
                ),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: () => _pickImage(context),
                icon: Icon(Icons.cloud, color: Colors.blue),

                label: Text(
                  'Pick Image from Gallery',
                  style: GoogleFonts.fredoka(
                    textStyle: const TextStyle(color: Colors.black),
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

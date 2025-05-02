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
                    height: 450,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.orange, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  )
                  : Center(
                    child: const Text(
                      'Upload an image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),

              const SizedBox(height: 30),

              if (nutrition != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Food: ${nutrition.food}',
                        style: GoogleFonts.fredoka(
                          textStyle: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Energy: ${nutrition.calories} kcal',
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Text(
                      'Protein: ${nutrition.sugar} g',
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Text(
                      'Fat: ${nutrition.fat} g',
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Text(
                      'Carbohydrates: ${nutrition.carbohydrates} g',
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Text(
                      'Sugar: ${nutrition.protein} g',
                      style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () => _pickImage(context),
                icon: Icon(Icons.cloud),
                label: Text('Pick Image from Gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:calories/providers/nutrition_provider.dart';
import 'package:flutter/material.dart';
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              image != null
                  ? Center(child: Image.file(image, height: 450))
                  : Center(
                    child: const Text(
                      'Upload an image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
              const SizedBox(height: 20),

              if (nutrition != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Food: ${nutrition.food}'),
                    Text('Estimated Calories: ${nutrition.calories} kcal'),
                    Text('Sugar: ${nutrition.sugar} g'),
                    Text('Carbohydrates: ${nutrition.carbohydrates} g'),
                    Text('Protein: ${nutrition.protein} g'),
                  ],
                ),

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

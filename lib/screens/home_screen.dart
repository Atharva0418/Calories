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
              image != null
                  ? Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
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

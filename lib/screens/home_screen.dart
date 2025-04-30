import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calories',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageFile == null
                ? Text(
                  'Upload an image',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                )
                : Text(
                  "Food: Athu\nEstimated Calories: 800kcal\nProtein:12g\nCarbohydrate:35g\nFat: 9g ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

            const SizedBox(height: 100),
            Center(
              child:
                  _imageFile != null
                      ? Image.file(_imageFile!, height: 470)
                      : SizedBox.shrink(),
            ),

            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.cloud),
                    label: Text('Pick Image from Gallery'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:calories/models/nutrition_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class NutritionProvider with ChangeNotifier {
  File? _imageFile;
  NutritionInfo? _nutritionInfo;

  File? get imageFile => _imageFile;

  NutritionInfo? get nutritionInfo => _nutritionInfo;

  void setImage(File image) {
    _imageFile = image;

    _nutritionInfo = NutritionInfo(
      food: "Athu",
      calories: 500,
      sugar: 20,
      carbohydrates: 50,
      protein: 12,
      fat: 9,
    );

    notifyListeners();
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    try {
      final uri = Uri.parse('http://10.0.2.2:8080/food/calories');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          await http.MultipartFile.fromPath(
            'image',
            _imageFile!.path,
            filename: basename(_imageFile!.path),
          ),
        );

      final response = await request.send();
    } catch (e) {
      debugPrint('Upload error: $e');
    }
  }

  void clear() {
    _imageFile = null;
    _nutritionInfo = null;
    notifyListeners();
  }
}

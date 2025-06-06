import 'dart:convert';
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
    notifyListeners();
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    try {
      final uri = Uri.parse('http://10.0.2.2:8080/gemini/analyze-nutrition');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          await http.MultipartFile.fromPath(
            'imageFile',
            _imageFile!.path,
            filename: basename(_imageFile!.path),
          ),
        );

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        _nutritionInfo = NutritionInfo.fromJson(jsonData);

        notifyListeners();
      }
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

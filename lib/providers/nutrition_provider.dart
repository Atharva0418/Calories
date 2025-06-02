import 'dart:convert';
import 'dart:io';

import 'package:calories/models/nutrition_info.dart';
import 'package:calories/models/screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class NutritionProvider with ChangeNotifier {
  ScreenState _state = ScreenState.idle;

  ScreenState? get state => _state;

  void _setScreenState(ScreenState newState) {
    _state = newState;
    notifyListeners();
  }

  File? _imageFile;
  NutritionInfo? _nutritionInfo;

  File? get imageFile => _imageFile;

  NutritionInfo? get nutritionInfo => _nutritionInfo;

  void setImage(File image) {
    _imageFile = image;
    notifyListeners();
  }

  Future<void> uploadImage() async {
    _setScreenState(ScreenState.loading);
    if (_imageFile == null) return;

    try {
      final uri = Uri.parse('http://10.0.2.2:8080/api/nutrition');
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
        _setScreenState(ScreenState.success);
      }
    } catch (e) {
      _setScreenState(ScreenState.error);
      debugPrint('Upload error: $e');
    }
  }

  void clear() {
    _imageFile = null;
    _nutritionInfo = null;
    notifyListeners();
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:calories/models/nutrition_info.dart';
import 'package:calories/models/screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void _setError(String message) {
    _errorMessage = message;
    _setScreenState(ScreenState.error);
  }

  Future<void> uploadImage() async {
    _setScreenState(ScreenState.loading);
    if (_imageFile == null) return;

    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/predict-nutrients');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          await http.MultipartFile.fromPath(
            'imageFile',
            _imageFile!.path,
            filename: basename(_imageFile!.path),
          ),
        );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          _setError("Request taking too long. Please try again later.");
          throw TimeoutException("Timed out");
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        _nutritionInfo = NutritionInfo.fromJson(jsonData);

        notifyListeners();
        _setScreenState(ScreenState.success);
      } else {
        final errorMsg = json
            .decode(response.body)
            .values
            .first
            .toString();
        _setError(errorMsg);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void reset() {
    _imageFile = null;
    _nutritionInfo = null;
    _setScreenState(ScreenState.idle);
    notifyListeners();
  }
}

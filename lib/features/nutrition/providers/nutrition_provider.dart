import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../models/nutrition_info.dart';

class NutritionProvider with ChangeNotifier {
  final AuthProvider authProvider;

  NutritionProvider({required this.authProvider});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

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

  Future<bool> uploadImage() async {
    _isLoading = true;
    notifyListeners();
    if (_imageFile == null) return false;
    try {
      final response = await authProvider.authenticatedRequest((
        accessToken,
      ) async {
        final uri = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/predict-nutrients',
        );
        final request =
            http.MultipartRequest('POST', uri)
              ..files.add(
                await http.MultipartFile.fromPath(
                  'imageFile',
                  _imageFile!.path,
                  filename: basename(_imageFile!.path),
                ),
              )
              ..headers.addAll({
                'x-api-key': '${dotenv.env['X_API_KEY']}',
                'Authorization': 'Bearer $accessToken',
              });

        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            _errorMessage = "Request taking too long. Please try again later.";
            throw TimeoutException("Timed out");
          },
        );

        return await http.Response.fromStream(streamedResponse);
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        _nutritionInfo = NutritionInfo.fromJson(jsonData);

        return true;
      } else {
        _errorMessage = json.decode(response.body).values.first.toString();
      }
      return false;
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again later.";
      debugPrint(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

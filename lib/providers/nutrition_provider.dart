import 'dart:io';

import 'package:calories/models/nutrition_info.dart';
import 'package:flutter/cupertino.dart';

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
    );

    notifyListeners();
  }

  void clear() {
    _imageFile = null;
    _nutritionInfo = null;
    notifyListeners();
  }
}

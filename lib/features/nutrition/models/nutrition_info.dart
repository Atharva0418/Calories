class NutritionInfo {
  final String food;
  final double energy;
  final double sugar;
  final double carbohydrates;
  final double protein;
  final double fat;

  NutritionInfo({
    required this.food,
    required this.energy,
    required this.sugar,
    required this.carbohydrates,
    required this.protein,
    required this.fat,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      food: json['food'],
      energy: json['energy'],
      sugar: json['sugar'],
      carbohydrates: json['carbohydrates'],
      protein: json['protein'],
      fat: json['fat'],
    );
  }

  @override
  String toString() {
    return 'NutritionInfo(food: $food, energy: $energy, sugar: $sugar, carbohydrates: $carbohydrates, protein: $protein, fat: $fat)';
  }
}

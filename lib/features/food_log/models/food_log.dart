import 'package:json_annotation/json_annotation.dart';

part 'food_log.g.dart';

@JsonSerializable()
class FoodLog {
  final String foodName;
  final double? weight;
  final double? protein;
  final double? carbohydrates;
  final double? sugar;
  final double? fat;
  final double? energy;

  FoodLog({
    required this.foodName,
    required this.weight,
    required this.protein,
    required this.carbohydrates,
    required this.sugar,
    required this.fat,
    required this.energy,
  });

  Map<String, dynamic> toJson() => _$FoodLogToJson(this);
}

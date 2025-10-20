// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodLog _$FoodLogFromJson(Map<String, dynamic> json) => FoodLog(
  id: json['id'] as String,
  foodName: json['foodName'] as String,
  weight: (json['weight'] as num?)?.toDouble(),
  protein: (json['protein'] as num?)?.toDouble(),
  carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
  sugar: (json['sugar'] as num?)?.toDouble(),
  fat: (json['fat'] as num?)?.toDouble(),
  energy: (json['energy'] as num?)?.toDouble(),
  timeStamp: DateTime.parse(json['timeStamp'] as String),
);

Map<String, dynamic> _$FoodLogToJson(FoodLog instance) => <String, dynamic>{
  'id': instance.id,
  'foodName': instance.foodName,
  'weight': instance.weight,
  'protein': instance.protein,
  'carbohydrates': instance.carbohydrates,
  'sugar': instance.sugar,
  'fat': instance.fat,
  'energy': instance.energy,
  'timeStamp': instance.timeStamp.toIso8601String(),
};

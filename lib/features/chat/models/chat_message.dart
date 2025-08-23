import 'package:calories/features/chat/models/message_role.dart';
import 'package:calories/features/nutrition/models/nutrition_info.dart';

class ChatMessage {
  final String text;
  final MessageRole role;
  final NutritionInfo? nutritionInfo;
  final bool isTyping;

  ChatMessage({
    required this.text,
    required this.role,
    this.nutritionInfo,
    this.isTyping = false,
  });
}

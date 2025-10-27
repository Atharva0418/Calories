import 'package:calories/features/nutrition/screens/views/error_view.dart';
import 'package:calories/features/nutrition/screens/views/loading_view.dart';
import 'package:calories/features/nutrition/screens/views/nutrition_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/screen_state.dart';
import '../providers/nutrition_provider.dart';
import '../widgets/header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = context.watch<NutritionProvider>();

    return Scaffold(appBar: const Header(), body: NutritionView());
  }
}

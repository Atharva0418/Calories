import 'package:calories/models/screen_state.dart';
import 'package:calories/providers/nutrition_provider.dart';
import 'package:calories/screens/views/error_view.dart';
import 'package:calories/screens/views/loading_view.dart';
import 'package:calories/screens/views/nutrition_view.dart';
import 'package:calories/screens/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = context.watch<NutritionProvider>();
    final nutrition = nutritionProvider.nutritionInfo;
    final state = nutritionProvider.state;

    return Scaffold(
      appBar: const Header(),

      body: Builder(
        builder: (context) {
          switch (state) {
            case ScreenState.loading:
              return const LoadingView();

            case ScreenState.error:
              return const ErrorView();

            case ScreenState.success:
            case ScreenState.idle:
            default:
              return NutritionView();
          }
        },
      ),
    );
  }
}

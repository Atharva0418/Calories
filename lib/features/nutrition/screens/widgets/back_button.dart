import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/nutrition_provider.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read<NutritionProvider>().reset();
      },
      label: const Text("Back"),
      icon: const Icon(Icons.arrow_back),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
    );
  }
}

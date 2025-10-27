import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pop();
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

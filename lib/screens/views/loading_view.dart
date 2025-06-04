import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/SearchingFood_colored.json',
        delegates: LottieDelegates(
          values: [
            ValueDelegate.color(['**'], value: Colors.orangeAccent),
          ],
        ),
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      ),
    );
  }
}

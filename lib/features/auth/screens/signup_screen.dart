import 'package:calories/features/auth/widgets/signup_form.dart';
import 'package:calories/features/nutrition/screens/widgets/header.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: const Padding(padding: EdgeInsets.all(16.0), child: SignupForm()),
    );
  }
}

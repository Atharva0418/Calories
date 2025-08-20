import 'package:calories/features/auth/widgets/signup_form.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(padding: EdgeInsets.all(16.0), child: SignupForm()),
    );
  }
}

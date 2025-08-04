import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;

  const PasswordInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: "Password"),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) return null;

        final regex = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&])[A-Za-z\d@#$!%*?&]{8,27}$',
        );

        if (!regex.hasMatch(value)) {
          return 'Password must contain at least one uppercase letter,\none lowercase letter, one digit, one special character\nand must be between 8 to 27 characters.';
        }
        return null;
      },
    );
  }
}

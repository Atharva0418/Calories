import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const EmailInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: "Email"),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter your email.';

        final regex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );

        if (!regex.hasMatch(value)) return 'Please use a valid email.';
        return null;
      },
    );
  }
}

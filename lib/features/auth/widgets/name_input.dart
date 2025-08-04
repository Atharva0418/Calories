import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  final TextEditingController controller;

  const NameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: "Name"),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter your name.';git

        final regex = RegExp(r'^[a-zA-Z]{1,12}$');

        if (!regex.hasMatch(value)) {
          return 'Name can be up to 12 characters and only contain letters.';
        }
        return null;
      },
    );
  }
}

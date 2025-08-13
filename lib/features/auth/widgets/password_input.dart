import 'package:calories/features/auth/providers/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;

  const PasswordInput({super.key, required this.controller});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final signupProvider = context.watch<SignupProvider>();
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: GoogleFonts.raleway(fontSize: 13),
        hintText: "Enter your password",
        hintStyle: GoogleFonts.fredoka(
          fontSize: 14,
          textStyle: TextStyle(color: Colors.grey),
        ),
        icon: Icon(Icons.lock),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        errorMaxLines: 3,
        errorText: signupProvider.fieldErrors['password'],

        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon:
              _obscureText
                  ? Icon(Icons.visibility_off, color: Colors.grey)
                  : Icon(Icons.visibility),
        ),
      ),
      obscureText: _obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password.";
        }

        final regex = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@_$#!%*?&])[A-Za-z\d@_#$!%*?&]{8,27}$',
        );

        if (!regex.hasMatch(value)) {
          return 'Password must have 8–27 characters, including uppercase, lowercase, number, and special character.';
        }
        return null;
      },
    );
  }
}

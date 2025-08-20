import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const EmailInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final signupProvider = context.watch<AuthProvider>();
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: GoogleFonts.raleway(fontSize: 13),
        hintText: "Enter your email.",
        hintStyle: GoogleFonts.fredoka(
          fontSize: 14,
          textStyle: TextStyle(color: Colors.grey),
        ),
        errorText: signupProvider.fieldErrors['email'],
        errorMaxLines: 2,
        icon: Icon(Icons.email),
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
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email.';

        final regex = RegExp(
          r'^(?=.{1,254}$)([a-zA-Z0-9._%+-]{1,64})@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$',
        );

        if (!regex.hasMatch(value)) return 'Please use a valid email.';
        return null;
      },
    );
  }
}

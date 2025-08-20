import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UsernameInput extends StatelessWidget {
  final TextEditingController controller;

  const UsernameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final signupProvider = context.watch<AuthProvider>();

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Username",
        labelStyle: GoogleFonts.raleway(fontSize: 13),
        hintText: "Enter your name.",
        hintStyle: GoogleFonts.fredoka(
          fontSize: 14,
          textStyle: TextStyle(color: Colors.grey),
        ),
        icon: Icon(Icons.person),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.r)),
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
        errorMaxLines: 2,
        errorText: signupProvider.fieldErrors['username'],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username.';
        }

        final regex = RegExp(r'^[a-zA-Z0-9]{1,12}$');

        if (!regex.hasMatch(value)) {
          return 'Name can be up to 12 characters and only contain letters and digits.';
        }
        return null;
      },
    );
  }
}

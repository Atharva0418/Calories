import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../home_screen.dart';

class SignupSuccessScreen extends StatefulWidget {
  const SignupSuccessScreen({super.key});

  @override
  State<SignupSuccessScreen> createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/Success.json',
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(['**'], value: Colors.orangeAccent),
                ],
              ),
              width: 250.w,
            ),

            Text(
              "You're officially on the menu 🍽️",
              style: GoogleFonts.baloo2(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

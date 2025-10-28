import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../home_screen.dart';

class LoginSuccessScreen extends StatefulWidget {
  const LoginSuccessScreen({super.key});

  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen> {
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
              "Welcome back, chef! 👨‍🍳",
              style: GoogleFonts.baloo2(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

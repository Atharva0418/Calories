import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:calories/features/auth/screens/login_success_screen.dart';
import 'package:calories/features/auth/screens/signup_screen.dart';
import 'package:calories/features/auth/widgets/email_input.dart';
import 'package:calories/features/auth/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/login_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final loginRequest = LoginRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final loginProvider = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final success = await loginProvider.login(loginRequest);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginSuccessScreen()),
      );
    } else {
      if (loginProvider.errorMessage != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(loginProvider.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = Colors.orangeAccent;
    final loginProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 200.h),
                  Text(
                    "Log in",
                    style: GoogleFonts.fredoka(
                      fontSize: 40.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  SizedBox(height: 20.h),
                  EmailInput(controller: _emailController),

                  SizedBox(height: 20.h),
                  PasswordInput(controller: _passwordController),

                  SizedBox(height: 40.h),

                  loginProvider.isLoading
                      ? Center(
                        child: Lottie.asset(
                          'assets/animations/SearchingFood_orange.json',
                          delegates: LottieDelegates(
                            values: [
                              ValueDelegate.color(['**'], value: themeColor),
                            ],
                          ),
                          height: 80.h,
                        ),
                      )
                      : SizedBox(
                        height: 60.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _submit();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Log in", style: TextStyle(fontSize: 18)),
                        ),
                      ),

                  SizedBox(height: 30.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16),
                      ),

                      TextButton(
                        onPressed: () {
                          loginProvider.fieldErrors.clear();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.only(left: 5),
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 17,
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:calories/features/auth/screens/login_screen.dart';
import 'package:calories/features/auth/screens/signup_success_screen.dart';
import 'package:calories/features/auth/widgets/email_input.dart';
import 'package:calories/features/auth/widgets/password_input.dart';
import 'package:calories/features/auth/widgets/username_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/signup_request.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = SignupRequest(
      username: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final signupProvider = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final success = await signupProvider.signup(request);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupSuccessScreen()),
      );
    } else {
      if (signupProvider.errorMessage != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(signupProvider.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = Colors.orangeAccent;
    final signupProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 200.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Sign up",
                        style: GoogleFonts.fredoka(
                          fontSize: 40.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  UsernameInput(controller: _nameController),

                  SizedBox(height: 20.h),
                  EmailInput(controller: _emailController),

                  SizedBox(height: 20.h),
                  PasswordInput(controller: _passwordController),

                  SizedBox(height: 40.h),

                  signupProvider.isLoading
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
                          child: Text(
                            "Sign up",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                  SizedBox(height: 30.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 16),
                      ),

                      TextButton(
                        onPressed: () {
                          signupProvider.fieldErrors.clear();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.only(left: 5),
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: TextStyle(color: themeColor),
                        ),
                        child: Text(
                          "Log in",
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

import 'package:calories/features/auth/models/signup_request.dart';
import 'package:calories/features/auth/providers/signup_provider.dart';
import 'package:calories/features/auth/widgets/email_input.dart';
import 'package:calories/features/auth/widgets/name_input.dart';
import 'package:calories/features/auth/widgets/password_input.dart';
import 'package:calories/features/nutrition/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
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
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final provider = context.read<SignupProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final success = await provider.signup(request);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      if (provider.errorMessage != null) {
        messenger.showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
      } else {
        messenger.showSnackBar(SnackBar(content: Text('Signup Successful')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignupProvider>();

    return SingleChildScrollView(
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
              NameInput(controller: _nameController),

              SizedBox(height: 20.h),
              EmailInput(controller: _emailController),

              SizedBox(height: 20.h),
              PasswordInput(controller: _passwordController),

              SizedBox(height: 40.h),

              SizedBox(
                width: double.infinity,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                            'Sign Up',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.only(left: 5),
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: TextStyle(color: Colors.orangeAccent),
                    ),
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.orangeAccent,
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
    );
  }
}

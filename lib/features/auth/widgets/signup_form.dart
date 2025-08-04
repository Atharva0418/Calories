import 'package:calories/features/auth/models/signup_request.dart';
import 'package:calories/features/auth/providers/signup_provider.dart';
import 'package:calories/features/auth/widgets/email_input.dart';
import 'package:calories/features/auth/widgets/name_input.dart';
import 'package:calories/features/auth/widgets/password_input.dart';
import 'package:calories/features/nutrition/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return Container(
      width: 350.w,
      height: 300.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withValues(alpha: 0.5),
            blurRadius: 10.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                NameInput(controller: _nameController),

                EmailInput(controller: _emailController),

                PasswordInput(controller: _passwordController),

                SizedBox(height: 20.h),

                ElevatedButton(
                  onPressed: provider.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

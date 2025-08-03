import 'package:calories/features/auth/models/signup_request.dart';
import 'package:calories/features/auth/providers/signup_provider.dart';
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
    await provider.signup(request);

    if (provider.errorMessage != null) {
      messenger.showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
    } else {
      messenger.showSnackBar(SnackBar(content: Text('Signup Successful')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignupProvider>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your name.';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your email.';
              }
              if (!value.contains('@')) {
                return 'Invalid Email.';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your password.';
              }

              return null;
            },
          ),

          SizedBox(height: 20.h),

          ElevatedButton(
            onPressed: provider.isLoading ? null : _submit,
            child:
                provider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}

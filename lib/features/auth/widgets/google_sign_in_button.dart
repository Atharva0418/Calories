import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:calories/features/auth/screens/login_success_screen.dart';
import 'package:calories/features/auth/screens/signup_success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  void _googleSignIn(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final success = await authProvider.googleSignIn();

    if (success) {
      if (authProvider.isNewUser! && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SignupSuccessScreen()),
        );
      } else {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginSuccessScreen()),
          );
        }
      }
    } else {
      if (authProvider.errorMessage != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _googleSignIn(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            'assets/images/google_logo.svg',
            width: 25.w,
            height: 25.h,
          ),

          Text(
            "Sign in with Google.",
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
        ],
      ),
    );
  }
}

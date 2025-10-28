import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final Color color1;
  final Color color2;

  const Header({required this.color1, required this.color2, super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return AppBar(
      title: Text(
        'Calories',
        style: GoogleFonts.dynaPuff(
          textStyle: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

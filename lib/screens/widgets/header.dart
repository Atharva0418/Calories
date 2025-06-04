import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.orangeAccent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/add_foodlog_screen.dart';

class LogCard extends StatefulWidget {
  const LogCard({super.key});

  @override
  State<LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(30.r);

    return Card(
      elevation: 6,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddFoodLogScreen(isEditing: false),
            ),
          );
        },
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),
        borderRadius: borderRadius,
        child: AnimatedScale(
          scale: isPressed ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: 140.h,
            width: 180.w,
            padding: EdgeInsets.only(top: 20.h, left: 20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.indigoAccent.withValues(alpha: 0.9),
                  Colors.lightBlue.withValues(alpha: 1.5),
                ],
              ),
              borderRadius: borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add a Bite",
                  style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Spacer(),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(right: 25.w, bottom: 20.h),
                  child: Icon(
                    FontAwesomeIcons.pencil,
                    size: 35,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/food_logs_history_screen.dart';

class HistoryCard extends StatefulWidget {
  const HistoryCard({super.key});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
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
            MaterialPageRoute(builder: (context) => FoodLogsHistoryScreen()),
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
                  Colors.green.withValues(alpha: 1),
                  Colors.lime.withValues(alpha: 1.2),
                ],
              ),
              borderRadius: borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Snack History",
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
                    Icons.history,
                    size: 45,
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

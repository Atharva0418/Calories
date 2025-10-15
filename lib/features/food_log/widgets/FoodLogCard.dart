import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodLogCard extends StatelessWidget {
  const FoodLogCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: Icon(Icons.fastfood_outlined, color: Colors.white),
                ),
                SizedBox(width: 10.w),
                Text(
                  "Apple",
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Expanded(
                  child: Text(
                    "15th October, 2025",
                    textAlign: TextAlign.end,
                    style: GoogleFonts.fredoka(fontWeight: FontWeight.w100),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Text("Protein : 20g"),
                SizedBox(width: 10.w),
                Text("Calories : 100kcal"),

                Expanded(
                  child: Text(
                    "21:11:20",
                    textAlign: TextAlign.end,
                    style: GoogleFonts.fredoka(fontWeight: FontWeight.w100),
                  ),
                ),
                // SizedBox(width: 65.w),
                // TextButton(
                //   onPressed: () {},
                //   style: TextButton.styleFrom(
                //     padding: EdgeInsets.zero,
                //     minimumSize: Size(0, 0),
                //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //   ),
                //   child: Icon(Icons.edit, size: 20, color: Colors.blueAccent),
                // ),
                //
                // SizedBox(width: 15.w),

                // TextButton(
                //   onPressed: () {},
                //   style: TextButton.styleFrom(
                //     padding: EdgeInsets.zero,
                //     minimumSize: Size(0, 0),
                //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //   ),
                //   child: Icon(Icons.delete, size: 20, color: Colors.red),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

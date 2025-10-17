import 'package:calories/features/food_log/models/food_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FoodLogCard extends StatelessWidget {
  final FoodLog foodLog;

  const FoodLogCard({required this.foodLog, super.key});

  @override
  Widget build(BuildContext context) {
    final String date = DateFormat('MMM d, yyyy').format(foodLog.timeStamp);
    final String time = DateFormat('Hm').format(foodLog.timeStamp);
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
                  foodLog.foodName,
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Expanded(
                  child: Text(
                    date,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.fredoka(fontWeight: FontWeight.w100),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Text("Protein : ${foodLog.protein}"),
                SizedBox(width: 10.w),
                Text("Energy : ${foodLog.energy}"),

                Expanded(
                  child: Text(
                    time,
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

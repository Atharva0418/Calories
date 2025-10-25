import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyTotal extends StatelessWidget {
  final String date;
  final Map<String, double> totals;

  const DailyTotal({required this.date, required this.totals, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      child: Icon(Icons.event_available, color: Colors.white),
                    ),
                    SizedBox(width: 10.w),
                    Text(date, style: GoogleFonts.fredoka()),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dailyTotalRow(
                      "Protein",
                      "${totals['protein']!.toStringAsFixed(0)} g",
                    ),

                    const Divider(thickness: 1, color: Colors.grey),

                    _dailyTotalRow(
                      "Carbohydrates",
                      "${totals['carbs']!.toStringAsFixed(0)} g",
                    ),

                    const Divider(thickness: 1, color: Colors.grey),

                    _dailyTotalRow(
                      "Sugar",
                      "${totals['sugar']!.toStringAsFixed(0)} g",
                    ),

                    const Divider(thickness: 1, color: Colors.grey),

                    _dailyTotalRow(
                      "Fat",
                      "${totals['fat']!.toStringAsFixed(0)} g",
                    ),

                    const Divider(thickness: 1, color: Colors.grey),

                    _dailyTotalRow(
                      "Energy",
                      "${totals['energy']!.toStringAsFixed(0)} kcal",
                    ),

                    const Divider(thickness: 1, color: Colors.grey),
                  ],
                ),
              ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total - Energy: ${totals['energy']!.toStringAsFixed(0)} kcal",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Protein: ${totals['protein']!.toStringAsFixed(1)} g",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dailyTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.fredoka(
            textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
          ),
        ),

        Text(
          value,
          style: GoogleFonts.fredoka(
            textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

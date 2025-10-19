import 'package:calories/features/food_log/models/food_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/food_log_provider.dart';

class FoodLogCard extends StatelessWidget {
  final FoodLog foodLog;

  const FoodLogCard({required this.foodLog, super.key});

  @override
  Widget build(BuildContext context) {
    final foodLogProvider = context.watch<FoodLogProvider>();
    final String date = DateFormat('MMM d, yyyy').format(foodLog.timeStamp);
    final String time = DateFormat('Hm').format(foodLog.timeStamp);
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: Text(foodLog.foodName),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.orangeAccent,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.redAccent,
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              foodLogProvider.deleteFoodLog(foodLog);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          );
        },
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

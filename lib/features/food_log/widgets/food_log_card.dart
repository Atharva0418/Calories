import 'package:calories/features/food_log/models/food_log.dart';
import 'package:calories/features/food_log/screens/add_foodlog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/food_log_provider.dart';

class FoodLogCard extends StatelessWidget {
  final FoodLog foodLog;

  const FoodLogCard({required this.foodLog, super.key});

  @override
  Widget build(BuildContext context) {
    final String time = DateFormat('Hm').format(foodLog.timeStamp.toLocal());

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (ctx) => Consumer<FoodLogProvider>(
                  builder: (context, provider, _) {
                    final updatedFoodLog = provider.foodLogs.firstWhere(
                      (log) => log.id == foodLog.id,
                      orElse: () => foodLog,
                    );

                    return AlertDialog(
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.orangeAccent,
                            child: Icon(
                              Icons.fastfood_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(updatedFoodLog.foodName),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFoodLogRow(
                            "Weight",
                            "${updatedFoodLog.weight}g",
                          ),

                          const Divider(thickness: 1, color: Colors.grey),

                          _buildFoodLogRow(
                            "Protein",
                            "${updatedFoodLog.protein}g",
                          ),

                          const Divider(thickness: 1, color: Colors.grey),

                          _buildFoodLogRow(
                            "Carbohydrates",
                            "${foodLog.carbohydrates}g",
                          ),

                          const Divider(thickness: 1, color: Colors.grey),

                          _buildFoodLogRow("Sugar", "${updatedFoodLog.sugar}g"),

                          const Divider(thickness: 1, color: Colors.grey),

                          _buildFoodLogRow("Fat", "${updatedFoodLog.fat}g"),

                          const Divider(thickness: 1, color: Colors.grey),

                          _buildFoodLogRow(
                            "Energy",
                            "${updatedFoodLog.energy} kcal",
                          ),

                          const Divider(thickness: 1, color: Colors.grey),
                        ],
                      ),
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => AddFoodLogScreen(
                                            isEditing: true,
                                            existingFoodLog: updatedFoodLog,
                                          ),
                                    ),
                                  );
                                },
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
                                  provider.deleteFoodLog(updatedFoodLog);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
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
                    child: Icon(FontAwesomeIcons.utensils, color: Colors.white),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    foodLog.foodName,
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text("Weight : ${foodLog.weight}g"),
                  SizedBox(width: 10.w),
                  Text("Protein : ${foodLog.protein}g"),
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

  Widget _buildFoodLogRow(String label, String value) {
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

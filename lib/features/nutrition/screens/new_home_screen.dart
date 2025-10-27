import 'package:calories/features/chat/widgets/chat_card.dart';
import 'package:calories/features/food_log/widgets/history_card.dart';
import 'package:calories/features/food_log/widgets/log_card.dart';
import 'package:calories/features/nutrition/providers/nutrition_provider.dart';
import 'package:calories/features/nutrition/screens/views/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/snap_card.dart';

class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const LoadingView();
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          top: 80.h,
                          left: -12.w,
                          child: Transform.scale(
                            scale: 0.7,
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/dot_grid.png',
                              color: Colors.indigoAccent,
                              fit: BoxFit.none,
                              alignment: Alignment.topLeft,
                              opacity: AlwaysStoppedAnimation(0.2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 50.h,
                            left: 30.w,
                            right: 20.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white.withValues(alpha: 0.0),
                                          Colors.blue.withValues(alpha: 0.1),
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      "Hey Atharva,",
                                      style: GoogleFonts.nunito(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                    child: Image.asset(
                                      'assets/images/calories_bot.gif',
                                      height: 140.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                "Spotted a snack?",
                                style: GoogleFonts.dynaPuff(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF9FA8DA), // muted blue
                                ),
                              ),
                              Text(
                                "Snap it! or Track it!",
                                style: GoogleFonts.dynaPuff(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF9FA8DA),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 100.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [SnapCard(), ChatCard()],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [LogCard(), HistoryCard()],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              padding: EdgeInsets.zero,
              elevation: 0,
              height: 60.h,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.withValues(alpha: 0.5)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.home_outlined), Text("Home")],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.logout_outlined), Text("Logout")],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

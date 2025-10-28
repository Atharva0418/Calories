import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:calories/features/chat/widgets/chat_card.dart';
import 'package:calories/features/food_log/widgets/history_card.dart';
import 'package:calories/features/food_log/widgets/log_card.dart';
import 'package:calories/features/nutrition/providers/nutrition_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'auth/screens/login_screen.dart';
import 'nutrition/views/loading_view.dart';
import 'nutrition/widgets/snap_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  late AnimationController _animationController;
  late Animation<Offset> _leftSlide;
  late Animation<Offset> _rightSlide;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _leftSlide = Tween<Offset>(
      begin: const Offset(-1.2, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _rightSlide = Tween<Offset>(
      begin: const Offset(1.2, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
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
                            child: SlideTransition(
                              position: _leftSlide,
                              child: Image.asset(
                                'assets/images/dot_grid.png',
                                color: Colors.indigoAccent,
                                fit: BoxFit.none,
                                alignment: Alignment.topLeft,
                                opacity: AlwaysStoppedAnimation(0.2),
                              ),
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
                                  SlideTransition(
                                    position: _leftSlide,
                                    child: Container(
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
                                        "Hey ${authProvider.username},",
                                        style: GoogleFonts.nunito(
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SlideTransition(
                                    position: _rightSlide,
                                    child: Image.asset(
                                      'assets/images/calories_bot.gif',
                                      height: 140.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20.h),

                              SlideTransition(
                                position: _leftSlide,
                                child: Column(
                                  children: [
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
                            children: [
                              SlideTransition(
                                position: _leftSlide,
                                child: SnapCard(),
                              ),

                              SlideTransition(
                                position: _rightSlide,
                                child: ChatCard(),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SlideTransition(
                                position: _leftSlide,
                                child: const LogCard(),
                              ),

                              SlideTransition(
                                position: _rightSlide,
                                child: const HistoryCard(),
                              ),
                            ],
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
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: Center(child: Text("Logout")),
                                content: Text(
                                  "Are you sure you want to logout?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await authProvider.logout();
                                      if (!context.mounted) return;
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (_) => LoginScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text("Logout"),
                                  ),
                                ],
                              ),
                        );
                      },
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

import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:calories/features/chat/provider/chat_provider.dart';
import 'package:calories/features/food_log/providers/food_log_provider.dart';
import 'package:calories/features/nutrition/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'features/auth/screens/signup_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/nutrition/providers/nutrition_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  final authProvider = AuthProvider();
  await authProvider.checkLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProxyProvider<AuthProvider, NutritionProvider>(
          create:
              (auth) =>
                  NutritionProvider(authProvider: auth.read<AuthProvider>()),
          update: (_, __, ___) => ___!,
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
          create:
              (auth) => ChatProvider(authProvider: auth.read<AuthProvider>()),
          update: (_, __, ___) => ___!,
        ),
        ChangeNotifierProxyProvider<AuthProvider, FoodLogProvider>(
          create:
              (auth) =>
                  FoodLogProvider(authProvider: auth.read<AuthProvider>()),
          update: (_, __, ___) => ___!,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return ScreenUtilInit(
      designSize: Size(411.42857142857144, 914.2857142857143),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Calories',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          routes: {ChatScreen.routeName: (context) => ChatScreen()},
          home:
              authProvider.isAuthenticated
                  ? const HomeScreen()
                  : const SignupScreen(),
        );
      },
    );
  }
}

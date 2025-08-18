import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'features/auth/screens/login_screen.dart';
import 'features/nutrition/providers/nutrition_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, NutritionProvider>(
          create:
              (auth) =>
                  NutritionProvider(authProvider: auth.read<AuthProvider>()),
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
          home: const LoginScreen(),
        );
      },
    );
  }
}

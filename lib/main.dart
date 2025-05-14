import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitPath',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        textTheme: GoogleFonts.istokWebTextTheme(),
        primaryColor: const Color(0xFF005DC8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005DC8),
          primary: const Color(0xFF005DC8),
          secondary: const Color(0xFF004AAE),
        ),
      ),
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('fr', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LoginScreen(),
    );
  }
}

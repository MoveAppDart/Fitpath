import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GymBro App',
      home: LoginScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(55, 81, 95, 1),
        fontFamily: GoogleFonts.itim().fontFamily
      ),
    );
  }
}

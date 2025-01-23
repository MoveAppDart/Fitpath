import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gymbro/screens/register/second_step_signup.dart';

class FirstStepSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic size, heights, width;
    size = MediaQuery.of(context).size;
    heights = size.height;
    width = size.width;
    return SafeArea(
      child: Scaffold(
          body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 0, 93, 200),
                Color.fromARGB(255, 1, 69, 148),
                Color.fromARGB(255, 1, 51, 109),
                Color.fromARGB(255, 2, 45, 96),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: heights / 30),
              // Progress Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      width: width/8,
                      height: 5,
                      decoration: BoxDecoration(
                        color: index == 0 ? const Color.fromARGB(255, 10, 187, 37) : const Color.fromARGB(255, 163, 172, 164),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: heights / 20),
              // Title and Subtitle
              Text(
                "How do you identify?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heights / 40),
              Text(
                "Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Morbi",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heights / 20),
              // Options
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    GenderOptionButton(
                      label: "Male",
                      icon: Icons.male,
                      onPressed: () {},
                    ),
                    GenderOptionButton(
                      label: "Female",
                      icon: Icons.female,
                      onPressed: () {},
                    ),
                    GenderOptionButton(
                      label: "Non-Binary",
                      icon: Icons.transgender,
                      onPressed: () {},
                    ),
                    GenderOptionButton(
                      label: "Prefer Not to disclose",
                      icon: Icons.close,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: 3.1416, // 90 grados en radianes (π/2)
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Previous",
                            style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600),
                            pageBuilder: (context, animation, secondaryAnimation) => SecondStepSignup(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: animation.value * 5, sigmaY: animation.value * 5),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(45, 124, 181, 1),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Continue",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.fast_forward_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heights / 30),
            ],
          ),
        ),
      ),
    );
  }
}

class GenderOptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const GenderOptionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(201, 255, 255, 255),
          padding: EdgeInsets.all(25), // Aumentar el padding vertical
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5, // Añadir sombra
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Centrar contenido
          children: [
            Icon(icon, color: const Color.fromARGB(255, 126, 126, 126), size: 30), // Tamaño del ícono
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(color: const Color.fromARGB(255, 126, 126, 126), fontSize: 17), // Tamaño del texto
            ),
          ],
        ),
      ),
    );
  }
}
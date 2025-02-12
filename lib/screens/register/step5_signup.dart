import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gymbro/screens/register/step4_signup.dart';
import 'package:gymbro/screens/register/step6_signup.dart';

class FifthStepSignup extends StatefulWidget {
  @override
  _FifthStepSignupState createState() => _FifthStepSignupState();
}

class _FifthStepSignupState extends State<FifthStepSignup> {
  String? selectedActivityLevel; // Variable para almacenar el género seleccionado

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
                      width: width / 8,
                      height: 5,
                      decoration: BoxDecoration(
                        color: index == 4
                            ? const Color.fromARGB(255, 10, 187, 37)
                            : const Color.fromARGB(178, 163, 172, 164),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: heights / 20),
              // Title and Subtitle
              Text(
                "What’s your activity level?",
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
              // Selector de Actividad
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    ActivityOptionButton(
                      label: "Sedentary",
                      icon: Icons.male,
                      isSelected: selectedActivityLevel == "Sedentary",
                      onPressed: () {
                        setState(() {
                          selectedActivityLevel = "Sedentary";
                        });
                      },
                    ),
                    ActivityOptionButton(
                      label: "Lightly Active",
                      icon: Icons.female,
                      isSelected: selectedActivityLevel == "Lightly Active",
                      onPressed: () {
                        setState(() {
                          selectedActivityLevel = "Lightly Active";
                        });
                      },
                    ),
                    ActivityOptionButton(
                      label: "Moderately Active",
                      icon: Icons.transgender,
                      isSelected: selectedActivityLevel == "Moderately Active",
                      onPressed: () {
                        setState(() {
                          selectedActivityLevel = "Moderately Active";
                        });
                      },
                    ),
                    ActivityOptionButton(
                      label: "Very Active",
                      icon: Icons.close,
                      isSelected: selectedActivityLevel == "Very Active",
                      onPressed: () {
                        setState(() {
                          selectedActivityLevel = "Very Active";
                        });
                      },
                    ),
                    ActivityOptionButton(
                      label: "Professional Athlete",
                      icon: Icons.close,
                      isSelected: selectedActivityLevel == "Professional Athlete",
                      onPressed: () {
                        setState(() {
                          selectedActivityLevel = "Professional Athlete";
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600),
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                FourthStepSignup(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: animation.value * 5,
                                      sigmaY: animation.value * 5),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: 3.1416,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Previous",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255)),
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
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                SixthStepSignup(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: animation.value * 5,
                                      sigmaY: animation.value * 5),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(45, 124, 181, 1),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityOptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const ActivityOptionButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? const Color.fromARGB(255, 45, 83, 181)
              : const Color.fromARGB(201, 255, 255, 255),
          padding: EdgeInsets.all(25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isSelected ? 10 : 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon,
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 126, 126, 126),
                size: 30),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 126, 126, 126),
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

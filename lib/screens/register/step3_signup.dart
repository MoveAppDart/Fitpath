import 'dart:ui';
import 'package:flutter/material.dart';
import 'step2_signup.dart';
import 'step4_signup.dart';
import '../utils/weightSlider.dart';

const greenColor = Color(0xff90D855);

class ThirdStepSignup extends StatefulWidget {
  const ThirdStepSignup({super.key});

  @override
  _ThirdStepSignupState createState() => _ThirdStepSignupState();
}

class _ThirdStepSignupState extends State<ThirdStepSignup> {
  double selectedWeight = 75; // Initial weight
  bool isKG = true; // New variable to track the unit

  // New method to convert weight for display
  String getDisplayWeight() {
    if (isKG) {
      return "${selectedWeight.toStringAsFixed(1)} Kgs";
    } else {
      return "${(selectedWeight * 2.20462).toStringAsFixed(1)} Lbs";
    }
  }

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
                        color: index == 2
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
                "How much your weight?",
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
              // Add the KG/LB selector
              Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isKG = true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isKG ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'KG',
                              style: TextStyle(
                                color: isKG ? Colors.blue : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isKG = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isKG ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'LB',
                              style: TextStyle(
                                color: !isKG ? Colors.blue : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heights / 40),
              // Update the weight display text to use the new method
              Text(
                getDisplayWeight(),
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Contenedor del slider de peso
              Container(
                height: 118,
                width: 300,
                decoration: BoxDecoration(
                  color: Color.fromARGB(229, 255, 255, 255),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: WeightSlider(
                  initialValue:
                      isKG ? selectedWeight : (selectedWeight * 2.20462),
                  isKG: isKG,
                  onChanged: (value) {
                    setState(() {
                      if (isKG) {
                        selectedWeight = value;
                      } else {
                        selectedWeight =
                            value / 2.20462; // Convert LBS to KG for storage
                      }
                    });
                  },
                ),
              ),
              Expanded(child: Container()),
              // Buttons
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SecondStepSignup(),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
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
              SizedBox(height: heights / 30),
            ],
          ),
        ),
      ),
    );
  }
}

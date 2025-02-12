import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gymbro/screens/bottom_navbar.dart';
import 'package:gymbro/screens/register/step5_signup.dart';

class SixthStepSignup extends StatefulWidget {
  @override
  _SixthStepSignupState createState() => _SixthStepSignupState();
}

class _SixthStepSignupState extends State<SixthStepSignup> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF005DC8),
                Color(0xFF014594),
                Color(0xFF01336D),
                Color(0xFF022D60),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.05),
              
              // Barra de progreso
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: LinearProgressIndicator(
                  value: 0.8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                ),
              ),
              
              SizedBox(height: size.height * 0.05),
              
              // Título
              Text(
                "What’s your goal?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              
              // Subtítulo
              Text(
                "Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Morbi",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: size.height * 0.08),
              
              // Contenedor de opciones
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: List.generate(4, (index) => RoundedBox()),
                ),
              ),
              
              Spacer(),
              
              // Botones de navegación
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                FifthStepSignup(),
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
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: 3.1416,
                            child: Icon(Icons.play_arrow_rounded, color: Colors.white),
                          ),
                          SizedBox(width: 5),
                          Text("Previous", style: TextStyle(color: Colors.white)),
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
                                BottomNavbar(),
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
                        backgroundColor: Color.fromRGBO(45, 124, 181, 1),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text("Finish", style: TextStyle(color: Colors.white)),
                          SizedBox(width: 5),
                          Icon(Icons.fast_forward_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context){
    dynamic size, heights, width;
    size = MediaQuery.of(context).size;
    heights = size.height;
    width = size.width;
    return Scaffold(
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: heights / 20),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(228, 255, 255, 255),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                       ],
                    ),                 
                    width: width - 40,
                    height: heights / 2,
                    child: Text("Calendario futuro..."),
                  ),
                ],
              ),
              SizedBox(width: width / 30,),
            ],
          ),
        ),
      
      ),
    ));
  }
}
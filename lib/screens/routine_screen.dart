import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: heights/30,),
            Text("Dia de pecho", style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),
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
              width: width,
              height: heights / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                ],
              ),
            ),
            SizedBox(height: heights/25,),
            Text("Dia de espalda", style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),
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
              width: width,
              height: heights / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                ],
              ),
            ),
            SizedBox(height: heights/25,),
          Text("Dia de pierna", style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),
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
              width: width,
              height: heights / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                ],
              ),
            ),
 
          ],
          
        ),
      ),
    ));
  }
}

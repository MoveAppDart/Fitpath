import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    dynamic size, heights, width;
    size = MediaQuery.of(context).size;
    heights = size.height;
    width = size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: heights/30,),
            Text("Progreso de ejercicios", style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),
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
            Text("Progreso de peso", style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),
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
          ], 
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              width: width,
              height: heights / 10,
              child: Row(
                children: [
                  SizedBox(width: width / 20),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(width: width / 20),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontFamily: GoogleFonts.itim().fontFamily),
                        children: [
                          TextSpan(
                            text: "Bienvenido de vuelta\n",
                            style: TextStyle(
                              fontWeight: FontWeight.w100, 
                              fontSize: 12,
                              color: Colors.white
                            ),
                          ),
                          TextSpan(
                            text: "Agustin Caraballo",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 17,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(Icons.notifications,  color: Colors.white,),
                  SizedBox(width: width / 20),
                ],
              ),
            ),
            SizedBox(height: heights/30,),
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
              height: heights / 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Porcentaje de rutina")
                ],
              ),
            ),
            SizedBox(height: heights/25,),
            Text("Dia de ...", style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),
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
            Text("Resumen semanal", style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),
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

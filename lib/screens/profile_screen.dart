import 'package:flutter/material.dart';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context){
    dynamic size, heights, width;
    size = MediaQuery.of(context).size;
    heights = size.height;
    width = size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: heights / 20),
              CircleAvatar(
                radius: 100, 
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person, 
                  size: 150,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: heights / 70),
              Text("Agustin Caraballo", style: TextStyle(fontSize: 20, color: Colors.white),),
              SizedBox(height: heights / 50),
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
                    width: width/2.3,
                    height: heights / 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                      ],
                    ),
                  ),
                  SizedBox(width: width/30,),
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
                    width: width/2.3,
                    height: heights / 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: heights/30,),
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
                    width: width/2.3,
                    height: heights / 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                      ],
                    ),
                  ),
                  SizedBox(width: width/30,),
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
                    width: width/2.3,
                    height: heights / 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      
      ),
    );
  }
}
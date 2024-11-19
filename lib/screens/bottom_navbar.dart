import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/calendar_screen.dart';
import 'package:flutter_application_2/screens/home_screen.dart';
import 'package:flutter_application_2/screens/profile_screen.dart';
import 'package:flutter_application_2/screens/routine_screen.dart';
import 'package:flutter_application_2/screens/stats_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  // Índice del botón seleccionado actualmente
  int selectedIndex = 1; 

  // Lista de iconos y nombres para los botones
  final List<Map<String, dynamic>> buttons = [
    {'icon': Icons.calendar_today, 'label': 'Calendario'},
    {'icon': Icons.home_outlined, 'label': 'Inicio'},
    {'icon': Icons.person, 'label': 'Perfil'},
    {'icon': Icons.bar_chart, 'label': 'Estadisticas'},
    {'icon': Icons.fitness_center, 'label': 'Rutina'},
  ];

  final List<Widget> pages = [
    CalendarScreen(),
    HomeScreen(),
    ProfileScreen(),
    StatsScreen(),
    RoutineScreen(),
  ];


  void onButtonTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedIndex >= 0 && selectedIndex < pages.length
          ? pages[selectedIndex]
          : const Center(child: Text('Seleccione una página.')),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 228, 133, 142),
          borderRadius: BorderRadius.circular(50), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BottomAppBar(
            color: Colors.transparent, 
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(buttons.length, (index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = (selectedIndex == index) ? -1 : index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 243, 179, 166),
                        borderRadius: isSelected
                            ? BorderRadius.circular(30)
                            : BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ]
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 12 : 12,
                          vertical: 10),
                      child: Row(
                        children: [
                          Icon(buttons[index]['icon'], color: Colors.white),
                          if (isSelected) ...[
                            Text(
                              buttons[index]['label'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

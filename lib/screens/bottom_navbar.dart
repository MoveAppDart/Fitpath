import 'package:fitpath/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';
import 'workouts_screen.dart';
import 'stats_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedIndex = 1;

  final List<Map<String, dynamic>> buttons = [
    {'icon': Icons.calendar_today, 'label': 'Calendar'},
    {'icon': Icons.home_outlined, 'label': 'Home'},
    {'icon': Icons.person, 'label': 'Profile'},
    {'icon': Icons.bar_chart, 'label': 'Stats'},
    {'icon': Icons.fitness_center, 'label': 'Routine'},
  ];

  final List<Widget> pages = [
    const CalendarScreen(),
    const HomeScreen(),
    const ProfileScreen(),
    const StatsScreen(),
    const WorkoutsScreen(),
  ];

  void onButtonTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Página actual
          Positioned.fill(
            child: pages[selectedIndex],
          ),

          // Navbar encima con z-index
          Positioned(
            bottom: 20, // Espaciado desde el borde inferior
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.78, 0.81, 0.84, 0.88, 1.0],
                  colors: [
                    Color(0xFF152CAF), // 78%
                    Color(0xFF142BAC), // 81%
                    Color(0xFF142AA9), // 84%
                    Color(0xFF142AA6), // 88%
                    Color(0xFF122699), // 100%
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BottomAppBar(
                  color: Colors.transparent,
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(buttons.length, (index) {
                      final isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: [0.0, 0.31],
                              colors: [
                                Color(0xFF1E40FF),
                                Color(0xFF1B3AE5),
                              ],
                            ),
                            borderRadius: isSelected
                                ? BorderRadius.circular(30)
                                : BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: isSelected ? 12 : 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(buttons[index]['icon'], color: Colors.white),
                              if (isSelected) ...[
                                Text(
                                  buttons[index]['label'],
                                  style: const TextStyle(color: Colors.white),
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
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../services/data_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int selectedDays = 15; // Default value

  // Maps to store different stats for different time periods
  final Map<int, Map<String, String>> exerciseStats = {
    7: {
      'Biceps1': '8%',
      'Biceps2': '7%',
      'Triceps1': '9%',
      'Biceps3': '6%',
      'Triceps2': '5%',
      'Biceps4': '8%',
      'Triceps3': '7%',
      'Biceps5': '5%',
    },
    15: {
      'Biceps1': '10%',
      'Biceps2': '10%',
      'Triceps1': '10%',
      'Biceps3': '10%',
      'Triceps2': '10%',
      'Biceps4': '10%',
      'Triceps3': '10%',
      'Biceps5': '10%',
    },
    21: {
      'Biceps1': '15%',
      'Biceps2': '12%',
      'Triceps1': '14%',
      'Biceps3': '13%',
      'Triceps2': '16%',
      'Biceps4': '15%',
      'Triceps3': '14%',
      'Biceps5': '17%',
    },
  };

  final Map<int, Map<String, String>> regionStats = {
    7: {'Arms': '30%', 'Back': '25%', 'Chest': '35%', 'Legs': '10%'},
    15: {'Arms': '40%', 'Back': '35%', 'Chest': '25%', 'Legs': '10%'},
    21: {'Arms': '45%', 'Back': '30%', 'Chest': '15%', 'Legs': '10%'},
  };

  @override
  Widget build(BuildContext context) {
    dynamic size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF005DC8),
              Color(0xFF004AAE),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile icon in top left
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.02),

                // Day selector
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: _buildDaySelector(7)),
                      Expanded(child: _buildDaySelector(15)),
                      Expanded(child: _buildDaySelector(21)),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.02),

                // Body diagram
                _buildStatsContainer(
                  height: height * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('body_front.png',
                          height: height * 0.2, color: Colors.black38),
                      SizedBox(width: 20),
                      Image.asset('body_back.png',
                          height: height * 0.2, color: Colors.black38),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.02),

                // Done exercises
                _buildStatsContainer(
                  height: height * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Done exercises',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildExerciseStats('Biceps1',
                                      exerciseStats[selectedDays]!['Biceps1']!),
                                  _buildExerciseStats('Biceps2',
                                      exerciseStats[selectedDays]!['Biceps2']!),
                                  _buildExerciseStats(
                                      'Triceps1',
                                      exerciseStats[selectedDays]![
                                          'Triceps1']!),
                                  _buildExerciseStats('Biceps3',
                                      exerciseStats[selectedDays]!['Biceps3']!),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildExerciseStats(
                                      'Triceps2',
                                      exerciseStats[selectedDays]![
                                          'Triceps2']!),
                                  _buildExerciseStats('Biceps4',
                                      exerciseStats[selectedDays]!['Biceps4']!),
                                  _buildExerciseStats(
                                      'Triceps3',
                                      exerciseStats[selectedDays]![
                                          'Triceps3']!),
                                  _buildExerciseStats('Biceps5',
                                      exerciseStats[selectedDays]!['Biceps5']!),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.02),

                // Trained regions
                _buildStatsContainer(
                  height: height * 0.2,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Trained regions',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              SizedBox(height: 10),
                              _buildLegendItem('Arms', Colors.blue,
                                  regionStats[selectedDays]!['Arms']!),
                              _buildLegendItem('Back', Colors.green,
                                  regionStats[selectedDays]!['Back']!),
                              _buildLegendItem('Chest', Colors.purple,
                                  regionStats[selectedDays]!['Chest']!),
                              _buildLegendItem('Legs', Colors.teal,
                                  regionStats[selectedDays]!['Legs']!),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CustomPaint(
                            painter:
                                PieChartPainter(selectedDays: selectedDays),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // Bottom navigation
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.calendar_today, true),
                      _buildNavItem(Icons.home, false),
                      _buildNavItem(Icons.person, false),
                      _buildNavItem(Icons.bar_chart, false),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.blue.shade800,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDaySelector(int days) {
    return GestureDetector(
      onTap: () => setState(() => selectedDays = days),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selectedDays == days ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            '$days days',
            style: TextStyle(
              color: selectedDays == days ? Colors.blue.shade800 : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsContainer({required double height, required Widget child}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  Widget _buildExerciseStats(String name, String percentage) {
    return Column(
      children: [
        Text(name, style: TextStyle(fontSize: 12, color: Colors.white)),
        Text(percentage,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: Colors.white)),
          SizedBox(width: 8),
          Text(percentage,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final int selectedDays;

  PieChartPainter({required this.selectedDays});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    // Draw pie chart sections
    double startAngle = 0;

    // Get percentages based on selected days
    double armsPercentage = double.parse(
        selectedDays == 7 ? '0.30' : (selectedDays == 15 ? '0.40' : '0.45'));
    double backPercentage = double.parse(
        selectedDays == 7 ? '0.25' : (selectedDays == 15 ? '0.35' : '0.30'));
    double chestPercentage = double.parse(
        selectedDays == 7 ? '0.35' : (selectedDays == 15 ? '0.25' : '0.15'));
    double legsPercentage = 0.10; // Constant for all periods

    // Arms
    paint.color = Colors.blue;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        2 * math.pi * armsPercentage, true, paint);

    startAngle += 2 * math.pi * armsPercentage;

    // Back
    paint.color = Colors.green;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        2 * math.pi * backPercentage, true, paint);

    startAngle += 2 * math.pi * backPercentage;

    // Chest
    paint.color = Colors.purple;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        2 * math.pi * chestPercentage, true, paint);

    startAngle += 2 * math.pi * chestPercentage;

    // Legs
    paint.color = Colors.teal;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        2 * math.pi * legsPercentage, true, paint);

    // Draw white circle in center for donut effect
    paint.color = Colors.white.withOpacity(0.2);
    canvas.drawCircle(center, radius * 0.5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

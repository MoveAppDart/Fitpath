import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int selectedDays = 15; // Valor por defecto

  @override
  Widget build(BuildContext context) {
    dynamic size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.05),
              
              // Selector de días
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDaySelector(7),
                    _buildDaySelector(15),
                    _buildDaySelector(21),
                  ],
                ),
              ),

              SizedBox(height: height * 0.02),

              // Diagrama del cuerpo
              _buildStatsContainer(
                height: height * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/body_front.png', color: Colors.black54),
                    SizedBox(width: 20),
                    Image.asset('assets/body_back.png', color: Colors.black54),
                  ],
                ),
              ),

              SizedBox(height: height * 0.02),

              // Ejercicios realizados
              _buildStatsContainer(
                height: height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Done exercises', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildExerciseStats('Biceps', '20%'),
                        _buildExerciseStats('Triceps', '30%'),
                        _buildExerciseStats('Shoulders', '25%'),
                        _buildExerciseStats('Back', '25%'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.02),

              // Regiones entrenadas
              _buildStatsContainer(
                height: height * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem('Arms', Colors.blue),
                        _buildLegendItem('Back', Colors.green),
                        _buildLegendItem('Chest', Colors.red),
                      ],
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      child: CustomPaint(
                        painter: PieChartPainter(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector(int days) {
    return GestureDetector(
      onTap: () => setState(() => selectedDays = days),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selectedDays == days ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$days days',
          style: TextStyle(
            color: selectedDays == days ? Colors.blue : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsContainer({required double height, required Widget child}) {
    return GestureDetector(
      onTap: () {}, // Añadir funcionalidad al hacer clic
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildExerciseStats(String name, String percentage) {
    return Column(
      children: [
        Text(name, style: TextStyle(fontSize: 12)),
        Text(percentage, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
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
        Text(text),
      ],
    );
  }
}

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Dibuja las secciones del pie chart
    double startAngle = 0;
    
    // Arms (40%)
    paint.color = Colors.blue;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, 2.5, true, paint);
    
    startAngle += 2.5;
    
    // Back (35%)
    paint.color = Colors.green;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, 2.2, true, paint);
    
    startAngle += 2.2;
    
    // Chest (25%)
    paint.color = Colors.red;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, 1.5, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

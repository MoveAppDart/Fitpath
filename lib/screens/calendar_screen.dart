import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005DC8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with profile picture and title
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Calendar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: CalendarFormat.month,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.white),
                    weekendStyle: TextStyle(color: Colors.white70),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.white),
                    weekendTextStyle: TextStyle(color: Colors.white70),
                    outsideTextStyle: TextStyle(color: Colors.white38),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF1A4B94),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Last Workouts Section
              Text(
                'Last Workouts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Workout List
              Expanded(
                child: ListView(
                  children: [
                    _buildWorkoutItem('15', 'Wed', 'Pull day', '6/6 exercises'),
                    _buildWorkoutItem('14', 'Tue', 'Full body workout', '5/6 exercises'),
                    _buildWorkoutItem('10', 'Fri', 'Leg day', '3/6 exercises'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(String day, String weekday, String title, String progress) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  day,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  weekday,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              width: 4,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    progress,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
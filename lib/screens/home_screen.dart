import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Providers
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';
import 'workout_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Get current date and calculate the week range
  final DateTime _now = DateTime.now();
  late final DateTime _weekStart;
  late final DateTime _weekEnd;
  late final List<DateTime> _weekDays;

  // User data
  final Map<String, dynamic> _userData = {
    'name': 'Cargando...',
    'email': '',
    'profileImage': '',
    'memberSince': '',
    'height': '',
    'weight': '',
    'age': 0,
  };

  List<Map<String, dynamic>> _upcomingWorkouts = [];
  List<Map<String, dynamic>> _recentWorkouts = [];
  Map<DateTime, List<String>> _workoutHistory = {};
  Map<String, dynamic> _nutritionData = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Calculate the start of the week (Monday)
    _weekStart = _now.subtract(Duration(days: _now.weekday - 1));
    // Calculate the end of the week (Sunday)
    _weekEnd = _weekStart.add(const Duration(days: 6));
    // Generate all days of the current week
    _weekDays = List.generate(7, (index) => _weekStart.add(Duration(days: index)));

    // Initialize with empty data
    _upcomingWorkouts = [];
    _recentWorkouts = [];
    _workoutHistory = {};
    _nutritionData = {};

    // Load real data from API
    _loadUserData();
    _loadWorkoutData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() => _isLoading = true);
      final success = await userProvider.loadUserProfile();
      
      if (success && userProvider.user != null && mounted) {
        setState(() {
          _userData.clear();
          _userData.addAll(userProvider.user!.toJson());
        });
      } else {
        final prefs = await SharedPreferences.getInstance();
        final savedName = prefs.getString('user_name');
        
        setState(() {
          _userData['name'] = savedName ?? 'Usuario';
        });
      }
    } catch (e) {
      setState(() => _userData['name'] = 'Usuario');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadWorkoutData() async {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    try {
      final success = await workoutProvider.loadWorkouts();
      
      if (success && workoutProvider.workouts.isNotEmpty && mounted) {
        setState(() {
          _processWorkoutData(workoutProvider.workouts);
        });
      }
      
      final startDate = _weekStart.toIso8601String().split('T')[0];
      final endDate = _weekEnd.toIso8601String().split('T')[0];
      final calendarSuccess = await workoutProvider.getWorkoutCalendar(startDate, endDate);
      
      if (calendarSuccess && workoutProvider.workoutCalendar != null && mounted) {
        setState(() {
          _processCalendarData(workoutProvider.workoutCalendar!);
        });
      }
    } catch (e) {
      print('Error loading workout data: $e');
    }
  }

  void _processWorkoutData(List<Workout> workouts) {
    final now = DateTime.now();
    final upcomingList = [];
    final recentList = [];

    for (var workout in workouts) {
      final workoutDate = workout.scheduledDate;

      if (workoutDate.isAfter(now)) {
        final String displayDate = workoutDate.day == now.day
            ? 'Hoy'
            : workoutDate.day == now.day + 1
                ? 'Mañana'
                : DateFormat('EEEE', 'es').format(workoutDate);

        upcomingList.add({
          'id': workout.id,
          'name': workout.name,
          'date': displayDate,
          'time': DateFormat('HH:mm').format(workoutDate),
          'duration': '${workout.duration} min',
          'type': workout.type,
        });
      } else if (workoutDate.isAfter(now.subtract(const Duration(days: 7)))) {
        recentList.add({
          'id': workout.id,
          'name': workout.name,
          'date': DateFormat('EEEE', 'es').format(workoutDate),
          'time': DateFormat('HH:mm').format(workoutDate),
          'duration': '${workout.duration} min',
          'type': workout.type,
          'completed': workout.completed,
        });
      }
    }

    if (upcomingList.isNotEmpty) {
      _upcomingWorkouts = List<Map<String, dynamic>>.from(
          upcomingList.map((workout) => Map<String, dynamic>.from(workout)));
    }

    if (recentList.isNotEmpty) {
      _recentWorkouts = List<Map<String, dynamic>>.from(
          recentList.map((workout) => Map<String, dynamic>.from(workout)));
    }
  }

  void _processCalendarData(Map<String, dynamic> calendarData) {
    final Map<DateTime, List<String>> historyMap = {};

    if (calendarData.containsKey('workouts')) {
      final workoutsList = calendarData['workouts'] as List<dynamic>;

      for (var workout in workoutsList) {
        if (workout['completed'] == true) {
          final workoutDate = DateTime.parse(workout['date']);
          final dateKey = DateTime(workoutDate.year, workoutDate.month, workoutDate.day);

          if (!historyMap.containsKey(dateKey)) {
            historyMap[dateKey] = [];
          }

          historyMap[dateKey]!.add(workout['name']);
        }
      }

      if (historyMap.isNotEmpty) {
        _workoutHistory = historyMap;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;
    final bool isDesktop = screenSize.width > 1200;
    final double horizontalPadding = isDesktop ? 80 : (isTablet ? 40 : 20);
    final double verticalSpacing = isDesktop ? 40 : (isTablet ? 30 : 24);
    final double headerFontSize = isDesktop ? 22 : (isTablet ? 20 : 18);
    final double subHeaderFontSize = isDesktop ? 18 : (isTablet ? 16 : 14);
    final double routineTitleFontSize = isDesktop ? 24 : (isTablet ? 22 : 20);

    // Format date range for weekly schedule
    final String weekRangeText =
        '${DateFormat('d MMM', 'es').format(_weekStart)} - ${DateFormat('d MMM y', 'es').format(_weekEnd)}';

    // Get today's workout if available
    final todaysWorkout = _upcomingWorkouts.firstWhere(
      (workout) => workout['date'] == 'Hoy',
      orElse: () => {
        'name': 'Sin entrenamiento',
        'time': 'No hay entrenamiento programado',
        'duration': '0 min',
        'id': ''
      },
    );

    // Calculate completed workouts for the week
    final int completedWorkouts = _weekDays
        .where((day) =>
            _workoutHistory.containsKey(DateTime(day.year, day.month, day.day)))
        .length;
    final int totalPlannedWorkouts = 4; // Example target
    final double progressValue = completedWorkouts / totalPlannedWorkouts;

    // Tamaños de fuente responsivos
    double textFieldFontSize = isDesktop ? 18 : (isTablet ? 16 : 14);
    double buttonFontSize = isDesktop ? 20 : (isTablet ? 18 : 16);
    double socialIconSize = isDesktop ? 40 : (isTablet ? 36 : 32);
    
    // Ajustar espaciado vertical si es necesario
    double adjustedVerticalSpacing = verticalSpacing;
    if (adjustedVerticalSpacing < 15) adjustedVerticalSpacing = 15;
    if (adjustedVerticalSpacing > 30) adjustedVerticalSpacing = 30;

    return Scaffold(
      body: Container(
        width: screenSize.width,
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
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 800 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with user info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: isDesktop ? 35 : (isTablet ? 30 : 25),
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.person,
                            size: isDesktop ? 40 : (isTablet ? 35 : 30),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: horizontalPadding * 0.2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bienvenido,',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: subHeaderFontSize,
                              ),
                            ),
                            _isLoading
                                ? const SizedBox(
                                    width: 100,
                                    child: LinearProgressIndicator(
                                      color: Colors.white,
                                      backgroundColor: Colors.transparent,
                                    ),
                                  )
                                : Text(
                                    _userData['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: headerFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing),

                    // Today's routine card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      padding: EdgeInsets.all(horizontalPadding * 0.5),
                      child: Column(
                        children: [
                          Text(
                            "Rutina de Hoy",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: routineTitleFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(horizontalPadding * 0.5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todaysWorkout['name'],
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: headerFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${todaysWorkout['time']} • ${todaysWorkout['duration']}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: subHeaderFontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: verticalSpacing * 0.8),
                          ElevatedButton(
                            onPressed: () {
                              if (todaysWorkout['name'] != 'Sin entrenamiento') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutDetailScreen(
                                      workoutId: todaysWorkout['id'],
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding * 0.5,
                                vertical: verticalSpacing * 0.3,
                              ),
                            ),
                            child: Text(
                              'Comenzar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: subHeaderFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalSpacing),

                    // Weekly progress
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      padding: EdgeInsets.all(horizontalPadding * 0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Progreso Semanal',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: headerFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    weekRangeText,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: subHeaderFontSize,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '¡Vas por buen camino!',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: subHeaderFontSize * 0.8,
                                    ),
                                  ),
                                  SizedBox(width: horizontalPadding * 0.2),
                                  SizedBox(
                                    width: isDesktop ? 50 : (isTablet ? 45 : 40),
                                    height: isDesktop ? 50 : (isTablet ? 45 : 40),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: progressValue,
                                          backgroundColor: Colors.white24,
                                          valueColor: const AlwaysStoppedAnimation<Color>(
                                            Color(0xFF00E5FF),
                                          ),
                                          strokeWidth: 4,
                                        ),
                                        Text(
                                          '$completedWorkouts/$totalPlannedWorkouts',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: subHeaderFontSize * 0.8,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: verticalSpacing),

                          // Weekly calendar
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(7, (index) {
                                final day = _weekDays[index];
                                final isToday = day.day == _now.day &&
                                    day.month == _now.month &&
                                    day.year == _now.year;
                                final hasWorkout = _workoutHistory.containsKey(
                                    DateTime(day.year, day.month, day.day));

                                return Container(
                                  width: 60,
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isToday
                                        ? const Color(0xFF00E5FF).withOpacity(0.2)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isToday
                                          ? const Color(0xFF00E5FF)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat('EEE', 'es').format(day)[0],
                                        style: TextStyle(
                                          color: isToday ? Colors.white : Colors.white70,
                                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isToday
                                              ? const Color(0xFF00E5FF)
                                              : Colors.transparent,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${day.day}',
                                            style: TextStyle(
                                              color: isToday ? Colors.black : Colors.white,
                                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (hasWorkout)
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF00E5FF),
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      else
                                        const SizedBox(height: 6),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalSpacing),

                    // Recent activities
                    if (_recentWorkouts.isNotEmpty) ...[
                      Text(
                        'Actividades Recientes',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: verticalSpacing * 0.5),
                      ..._recentWorkouts.take(3).map((workout) => Card(
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00E5FF).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.directions_run,
                              color: Color(0xFF00E5FF),
                            ),
                          ),
                          title: Text(
                            workout['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${workout['date']} • ${workout['time']}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: subHeaderFontSize * 0.9,
                            ),
                          ),
                          trailing: Text(
                            workout['duration'],
                            style: const TextStyle(
                              color: Color(0xFF00E5FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutDetailScreen(
                                  workoutId: workout['id'],
                                ),
                              ),
                            );
                          },
                        ),
                      )).toList(),
                      SizedBox(height: verticalSpacing),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

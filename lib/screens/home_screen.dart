import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'workout_detail_screen.dart';
import 'package:intl/intl.dart';

// Servicios y providers
import '../services/data_service.dart'; // Servicio de datos mock
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';

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

  // Add these variables for data
  late final Map<String, dynamic> _userData;
  late final List<Map<String, dynamic>> _upcomingWorkouts;
  late final List<Map<String, dynamic>> _recentWorkouts;
  late final Map<DateTime, List<String>> _workoutHistory;
  late final Map<String, dynamic> _nutritionData;

  @override
  void initState() {
    super.initState();
    // Calculate the start of the week (Monday)
    _weekStart = _now.subtract(Duration(days: _now.weekday - 1));
    // Calculate the end of the week (Sunday)
    _weekEnd = _weekStart.add(const Duration(days: 6));
    // Generate all days of the current week
    _weekDays =
        List.generate(7, (index) => _weekStart.add(Duration(days: index)));

    // Cargar datos iniciales desde el servicio mock
    _userData = DataService.getUserProfile();
    _upcomingWorkouts = DataService.getUpcomingWorkouts();
    _recentWorkouts = DataService.getRecentWorkouts();
    _workoutHistory = DataService.getWorkoutHistory();
    _nutritionData = DataService.getNutritionData();

    // Cargar datos reales desde la API
    _loadUserData();
    _loadWorkoutData();
  }

  Future<void> _loadUserData() async {
    // Obtener el provider de usuario
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Cargar el perfil del usuario
      final success = await userProvider.loadUserProfile();

      // Si se obtuvieron datos correctamente, actualizar la UI
      if (success && userProvider.user != null && mounted) {
        setState(() {
          // Convertir el objeto User a un Map para mantener la compatibilidad con el código existente
          _userData = userProvider.user!.toJson();
        });
      }
    } catch (e) {
      // En caso de error, mantener los datos mock
      print('Error al cargar datos del usuario: $e');
    }
  }

  Future<void> _loadWorkoutData() async {
    // Obtener el provider de entrenamientos
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);

    try {
      // Cargar la lista de entrenamientos
      final success = await workoutProvider.loadWorkouts();

      // Si se obtuvieron datos correctamente, actualizar la UI
      if (success && workoutProvider.workouts.isNotEmpty && mounted) {
        setState(() {
          // Actualizar los entrenamientos próximos y recientes
          _processWorkoutData(workoutProvider.workouts);
        });
      }
      
      // Cargar el calendario de entrenamientos para la semana actual
      final startDate = _weekStart.toIso8601String().split('T')[0];
      final endDate = _weekEnd.toIso8601String().split('T')[0];
      final calendarSuccess = await workoutProvider.getWorkoutCalendar(startDate, endDate);
      
      if (calendarSuccess && workoutProvider.workoutCalendar != null && mounted) {
        setState(() {
          // Actualizar el historial de entrenamientos con los datos del calendario
          _processCalendarData(workoutProvider.workoutCalendar!);
        });
      }
    } catch (e) {
      // En caso de error, mantener los datos mock
      print('Error al cargar datos de entrenamientos: $e');
    }
  }
  
  // Procesa los datos de entrenamientos para adaptarlos al formato de la UI
  void _processWorkoutData(List<Workout> workouts) {
    // Aquí se mapean los datos de la API al formato esperado por la UI
    // Por ejemplo, clasificar los entrenamientos en próximos y recientes
    final now = DateTime.now();
    final upcomingList = [];
    final recentList = [];
    
    for (var workout in workouts) {
      final workoutDate = workout.scheduledDate;
      
      if (workoutDate.isAfter(now)) {
        // Es un entrenamiento próximo
        final String displayDate = workoutDate.day == now.day ? 'Today' : 
                                  workoutDate.day == now.day + 1 ? 'Tomorrow' : 
                                  DateFormat('EEEE').format(workoutDate);
        
        upcomingList.add({
          'id': workout.id,
          'name': workout.name,
          'date': displayDate,
          'time': DateFormat('HH:mm').format(workoutDate),
          'duration': '${workout.duration} min',
          'type': workout.type,
        });
      } else if (workoutDate.isAfter(now.subtract(const Duration(days: 7)))) {
        // Es un entrenamiento reciente (última semana)
        recentList.add({
          'id': workout.id,
          'name': workout.name,
          'date': DateFormat('EEEE').format(workoutDate),
          'time': DateFormat('HH:mm').format(workoutDate),
          'duration': '${workout.duration} min',
          'type': workout.type,
          'completed': workout.completed,
        });
      }
    }
    
    // Actualizar los datos solo si hay información nueva
    if (upcomingList.isNotEmpty) {
      _upcomingWorkouts = List<Map<String, dynamic>>.from(upcomingList.map((workout) => Map<String, dynamic>.from(workout)));
    }
    
    if (recentList.isNotEmpty) {
      _recentWorkouts = List<Map<String, dynamic>>.from(recentList.map((workout) => Map<String, dynamic>.from(workout)));
    }
  }
  
  // Procesa los datos del calendario para adaptarlos al formato de la UI
  void _processCalendarData(Map<String, dynamic> calendarData) {
    // Convertir los datos del calendario al formato esperado por la UI
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
      
      // Actualizar el historial de entrenamientos
      if (historyMap.isNotEmpty) {
        _workoutHistory = historyMap;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and determine device type
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;
    final bool isDesktop = screenSize.width > 1200;

    // Responsive values
    final double horizontalPadding = isDesktop ? 80 : (isTablet ? 40 : 20);
    final double verticalSpacing = isDesktop ? 40 : (isTablet ? 30 : 24);

    // Responsive text sizes
    final double headerFontSize = isDesktop ? 22 : (isTablet ? 20 : 18);
    final double subHeaderFontSize = isDesktop ? 18 : (isTablet ? 16 : 14);
    final double routineTitleFontSize = isDesktop ? 24 : (isTablet ? 22 : 20);

    // Format date range for weekly schedule
    final String weekRangeText =
        '${DateFormat('MMMM d').format(_weekStart)}-${DateFormat('d').format(_weekEnd)}';

    // Get today's workout if available
    final todaysWorkout = _upcomingWorkouts.firstWhere(
      (workout) => workout['date'] == 'Today',
      orElse: () => {
        'name': 'Rest Day',
        'time': 'No workout scheduled',
        'duration': '0 min'
      },
    );

    // Calculate completed workouts for the week
    final int completedWorkouts = _weekDays
        .where((day) =>
            _workoutHistory.containsKey(DateTime(day.year, day.month, day.day)))
        .length;
    final int totalPlannedWorkouts = 4; // Example target
    final double progressValue = completedWorkouts / totalPlannedWorkouts;

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
        child: Center(
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
                    // Top margin
                    SizedBox(height: verticalSpacing),

                    // Header with user info and notification
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nice to see you again,',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: subHeaderFontSize,
                                ),
                              ),
                              Text(
                                _userData['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: headerFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
                            "Today's routine",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: routineTitleFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          Container(
                            width: double.infinity,
                            height: screenSize.height * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(horizontalPadding * 0.3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  todaysWorkout['name'],
                                  style: TextStyle(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkoutDetailScreen(
                                    workoutName: todaysWorkout['name'],
                                  ),
                                ),
                              );
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
                              'Start',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: subHeaderFontSize,
                              ),
                            ),
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003366),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: verticalSpacing * 0.5,
                                ),
                              ),
                              child: Text(
                                'My workouts',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: subHeaderFontSize,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalSpacing),

                    // Weekly schedule section
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
                          // Weekly schedule header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Weekly schedule',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: headerFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    weekRangeText, // Display actual date range
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
                                    'Just ${totalPlannedWorkouts - completedWorkouts} workout more!',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: subHeaderFontSize * 0.8,
                                    ),
                                  ),
                                  SizedBox(width: horizontalPadding * 0.2),
                                  SizedBox(
                                    width:
                                        isDesktop ? 50 : (isTablet ? 45 : 40),
                                    height:
                                        isDesktop ? 50 : (isTablet ? 45 : 40),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: progressValue,
                                          backgroundColor: Colors.white24,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(
                                            Color(0xFF7BA69A),
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

                          // Day cards
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(7, (i) {
                              // Fixed width for day cards to avoid shrinking
                              final double cardWidth =
                                  isDesktop ? 60 : (isTablet ? 55 : 50);
                              final double cardHeight =
                                  isDesktop ? 80 : (isTablet ? 70 : 60);

                              // Get the day for this card
                              final DateTime day = _weekDays[i];
                              final bool isToday = day.day == _now.day &&
                                  day.month == _now.month &&
                                  day.year == _now.year;

                              // Check if there's a workout for this day
                              final bool hasWorkout =
                                  _workoutHistory.containsKey(
                                      DateTime(day.year, day.month, day.day));

                              return Container(
                                width: cardWidth,
                                height: cardHeight,
                                padding: EdgeInsets.all(
                                  horizontalPadding * 0.1,
                                ),
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? const Color(0xFF003366)
                                      : Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      day.day
                                          .toString(), // Display actual day number
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: subHeaderFontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('E')
                                          .format(day), // Mon, Tue, etc.
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: subHeaderFontSize * 0.8,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    // Show indicator for days with workouts
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: hasWorkout
                                            ? const Color(0xFF7BA69A)
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalSpacing),

                    // Health Care section
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
                          Text(
                            'Health Care',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: headerFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: verticalSpacing * 0.8),
                          Row(
                            children: [
                              // Day Activity Container
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding * 0.2,
                                  vertical: verticalSpacing * 0.4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF003366),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Day Activity',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: subHeaderFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: verticalSpacing * 0.2),
                                    Icon(
                                      Icons.fitness_center,
                                      color: Colors.white,
                                      size:
                                          isDesktop ? 35 : (isTablet ? 30 : 25),
                                    ),
                                    SizedBox(height: verticalSpacing * 0.2),
                                    Text(
                                      _nutritionData['calories']['burned']
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: headerFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'kcal',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: subHeaderFontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: horizontalPadding * 0.3),
                              // Sleep Time Section
                              Expanded(
                                child: Container(
                                  // Increased padding for Sleep Time card
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding * 0.4,
                                    vertical: verticalSpacing * 0.4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Sleep Time',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: headerFontSize,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  horizontalPadding * 0.1,
                                              vertical: verticalSpacing * 0.1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF7BA69A)
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '7:30h',
                                              style: TextStyle(
                                                color: const Color(0xFF7BA69A),
                                                fontSize: subHeaderFontSize,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: verticalSpacing * 0.2),
                                      Text(
                                        "You're awesome!",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: subHeaderFontSize,
                                        ),
                                      ),
                                      SizedBox(height: verticalSpacing * 0.3),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: 0.9,
                                          backgroundColor: Colors.white24,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(
                                            Color(0xFF7BA69A),
                                          ),
                                          minHeight: verticalSpacing * 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'workout_detail_screen.dart';
import 'package:intl/intl.dart';
import '../services/data_service.dart'; // Add this import

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

    // Load data from DataService
    _userData = DataService.getUserProfile();
    _upcomingWorkouts = DataService.getUpcomingWorkouts();
    _recentWorkouts = DataService.getRecentWorkouts();
    _workoutHistory = DataService.getWorkoutHistory();
    _nutritionData = DataService.getNutritionData();
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
                  minHeight: screenSize.height,
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
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
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
                              color: Colors.white.withValues(alpha: 0.78),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(horizontalPadding * 0.3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  todaysWorkout['name'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: headerFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${todaysWorkout['time']} • ${todaysWorkout['duration']}',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
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
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding * 2.5,
                                vertical: verticalSpacing * 0.7,
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
                                backgroundColor:
                                    const Color.fromARGB(125, 0, 85, 77),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: verticalSpacing * 1,
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
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
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
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                  isDesktop ? 62 : (isTablet ? 57 : 52);
                              final double cardHeight =
                                  isDesktop ? 90 : (isTablet ? 80 : 70);

                              // Get the day for this card
                              final DateTime day = _weekDays[i];
                              final bool isToday = day.day == _now.day &&
                                  day.month == _now.month &&
                                  day.year == _now.year;

                              // Set border radius for the first and last cards
                              BorderRadius borderRadius = BorderRadius.zero;
                              if (i == 0) {
                                borderRadius = const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                );
                              } else if (i == 6) {
                                borderRadius = const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                );
                              }

                              // Check if there's a workout for this day
                              final bool hasWorkout =
                                  _workoutHistory.containsKey(
                                      DateTime(day.year, day.month, day.day));

                              return Container(
                                width: cardWidth,
                                height: isToday ? cardHeight * 1.2 : cardHeight,
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? const Color.fromARGB(117, 1, 52, 47)
                                      : const Color.fromARGB(255, 194, 194, 194)
                                          .withValues(alpha: 0.79),
                                  borderRadius: borderRadius,
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
                                    // Show indicator for days with workouts
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: hasWorkout
                                            ? const Color.fromARGB(
                                                255, 10, 143, 30)
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    // Show day of the week
                                    Text(
                                      DateFormat('E')
                                          .format(day), // Mon, Tue, etc.
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: subHeaderFontSize * 0.8,
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
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
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
                                child: SizedBox(
                                  width: isDesktop ? 95 : (isTablet ? 75 : 55),
                                  height: isDesktop ? 170 : (isTablet ? 150 : 130),
                                  child: _DayActivityCard(
                                    title: '',
                                    value: _nutritionData['calories']['burned'].toString(),
                                  ),
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
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
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
                                                  .withValues(alpha: 0.2),
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


class _DayActivityCard extends StatelessWidget {
  final String title;
  final String value;

  const _DayActivityCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0E3F5B),
            Color(0xFF0B2B46),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 7),
          ),
        ],
      ),
child: ClipRRect(
  borderRadius: BorderRadius.circular(14),
  child: Stack(
    children: [
      Align(
        alignment: Alignment.bottomCenter,
        child: ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 70,
            color: const Color(0xFF7C8D99).withValues(alpha: 0.85),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.fitness_center, color: Colors.white, size: 17),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            const Text('kcal', style: TextStyle(color: Colors.white70, fontSize: 9)),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();
    p.lineTo(0, size.height * 0.55);

    // primera curva (sube)
    p.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.35,
      size.width * 0.5,
      size.height * 0.55,
    );

    // segunda curva (baja)
    p.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.75,
      size.width,
      size.height * 0.55,
    );

    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

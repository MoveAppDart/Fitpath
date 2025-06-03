import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Providers
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
// Models
import '../models/workout.dart';
// Screens
// import './workout_detail_screen.dart'; // Ensure this screen exists and takes workoutId (Currently unused)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final DateTime _now = DateTime.now();
  late DateTime _weekStart;
  late DateTime _weekEnd; // Now used for weekRangeText
  late List<DateTime> _weekDays;

  Map<String, dynamic> _userData = {'name': 'Loading...'};
  List<Workout> _upcomingWorkouts = [];
  List<Workout> _recentWorkouts = [];
  Map<DateTime, List<Workout>> _workoutCalendarEvents =
      {}; // Store full Workout objects for calendar events

  bool _isLoadingUserData = true;
  bool _isLoadingWorkouts = true;

  // Theme Colors (consider moving to a central theme file)
  static const Color primaryBlue =
      Color(0xFF0A7AFF); // A slightly brighter, modern blue
  static const Color darkBackgroundBlue = Color(0xFF001E3C);
  static const Color cardBlue = Color(0xFF003D7A); // For cards
  static const Color accentColor =
      Color(0xFF00E676); // A vibrant green/teal for accents
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;
  static const Color textWhite54 = Colors.white54;

  @override
  void initState() {
    super.initState();
    _calculateWeekRange();
    // Load data after the first frame to allow context to be available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _calculateWeekRange() {
    _weekStart = _now.subtract(Duration(days: _now.weekday - 1));
    _weekEnd = _weekStart.add(const Duration(days: 6));
    _weekDays =
        List.generate(7, (index) => _weekStart.add(Duration(days: index)));
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    // Load user data first, then workouts as they might depend on user context
    // (though current implementation doesn't show direct dependency for workout loading)
    await _loadUserData();
    await _loadWorkoutData();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() => _isLoadingUserData = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      bool profileLoaded = await userProvider.loadUserProfile();
      if (profileLoaded && userProvider.user != null && mounted) {
        setState(() => _userData = userProvider.user!.toJson());
        print('HomeScreen: User profile loaded: ${_userData['name']}');
      } else {
        final prefs = await SharedPreferences.getInstance();
        final savedName = prefs.getString('user_name');
        if (mounted) setState(() => _userData['name'] = savedName ?? 'User');
        print('HomeScreen: Used fallback name: ${_userData['name']}');
      }
    } catch (e) {
      if (mounted) setState(() => _userData['name'] = 'User');
      print('HomeScreen: Error loading user data: $e');
    } finally {
      if (mounted) setState(() => _isLoadingUserData = false);
    }
  }

  Future<void> _loadWorkoutData() async {
    if (!mounted) return;
    setState(() => _isLoadingWorkouts = true);

    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);
    try {
      await workoutProvider
          .loadWorkouts(); // Assumes this fetches all user's workouts
      if (mounted) {
        _processAndSetWorkoutData(workoutProvider.workouts);
      }
      // Load calendar-specific view if your API supports it, or process all workouts
      // For now, _processAndSetWorkoutData also populates _workoutCalendarEvents
    } catch (e) {
      print('HomeScreen: Error loading workout data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading workouts: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingWorkouts = false);
    }
  }

  void _processAndSetWorkoutData(List<Workout> allWorkouts) {
    final now = DateTime.now();
    final todayDateOnly = DateTime(now.year, now.month, now.day);

    List<Workout> upcoming = [];
    List<Workout> recent = [];
    Map<DateTime, List<Workout>> calendarEvents = {};

    for (var workout in allWorkouts) {
      final workoutDate = workout.scheduledDate;
      final workoutDateOnly =
          DateTime(workoutDate.year, workoutDate.month, workoutDate.day);

      // Populate calendar events
      if (calendarEvents.containsKey(workoutDateOnly)) {
        calendarEvents[workoutDateOnly]!.add(workout);
      } else {
        calendarEvents[workoutDateOnly] = [workout];
      }

      // Populate upcoming and recent lists
      if (workoutDateOnly.isAfter(todayDateOnly) ||
          workoutDateOnly.isAtSameMomentAs(todayDateOnly)) {
        upcoming.add(workout);
      } else if (workoutDateOnly
          .isAfter(todayDateOnly.subtract(const Duration(days: 7)))) {
        recent.add(workout);
      }
    }

    upcoming.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
    recent.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));

    if (mounted) {
      setState(() {
        _upcomingWorkouts = upcoming;
        _recentWorkouts = recent;
        _workoutCalendarEvents = calendarEvents;
      });
    }
  }

  // Helper to get events for TableCalendar
  List<Workout> _getEventsForCalendarDay(DateTime day) {
    return _workoutCalendarEvents[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width >= 600;
    final bool isDesktop = screenSize.width >=
        960; // Adjusted for better desktop layout consideration

    final double horizontalPadding = isDesktop ? 32 : (isTablet ? 24 : 16);
    final double verticalCardSpacing = isDesktop ? 24 : (isTablet ? 20 : 16);
    final double headerFontSize = (screenSize.width * 0.05).clamp(20.0, 28.0);
    final double subHeaderFontSize =
        (screenSize.width * 0.035).clamp(14.0, 18.0);
    final double cardTitleFontSize =
        (screenSize.width * 0.045).clamp(18.0, 22.0);

    String greetingName =
        _isLoadingUserData ? "Loading..." : (_userData['name'] ?? 'User');

    Workout? todaysWorkout;
    if (_upcomingWorkouts.isNotEmpty) {
      final today = DateTime.now();
      todaysWorkout = _upcomingWorkouts.firstWhere(
        (w) =>
            w.scheduledDate.year == today.year &&
            w.scheduledDate.month == today.month &&
            w.scheduledDate.day == today.day,
        orElse: () => _upcomingWorkouts
            .first, // Fallback to next upcoming if none for today
      );
    }

    int completedThisWeek = 0;
    for (var day in _weekDays) {
      if (_workoutCalendarEvents[DateTime(day.year, day.month, day.day)]
              ?.any((w) => w.completed) ??
          false) {
        completedThisWeek++;
      }
    }
    // Define weekRangeText here
    final String weekRangeText =
        "${DateFormat.MMMd().format(_weekStart)} - ${DateFormat.MMMd().format(_weekEnd)}";

    // TODO: Get totalPlannedWorkouts dynamically or from user settings
    int totalPlannedWorkouts = 5; // Example
    double weeklyProgress = totalPlannedWorkouts > 0
        ? (completedThisWeek / totalPlannedWorkouts).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: darkBackgroundBlue,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadInitialData,
          color: textWhite,
          backgroundColor: primaryBlue,
          child: CustomScrollView(
            // Use CustomScrollView for more complex scrollable layouts
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalCardSpacing * 0.8),
                sliver: SliverToBoxAdapter(
                  child: _buildUserHeader(
                      greetingName,
                      _userData['profileImage'],
                      headerFontSize,
                      subHeaderFontSize,
                      isDesktop,
                      isTablet),
                ),
              ),

              if (_isLoadingWorkouts && _upcomingWorkouts.isEmpty)
                const SliverFillRemaining(
                    child: Center(
                        child: CircularProgressIndicator(color: textWhite))),

              if (!_isLoadingWorkouts && todaysWorkout != null)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: SliverToBoxAdapter(
                      child: _buildTodaysRoutineCard(
                          todaysWorkout,
                          cardTitleFontSize,
                          subHeaderFontSize,
                          verticalCardSpacing)),
                ),

              if (!_isLoadingWorkouts)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      verticalCardSpacing,
                      horizontalPadding,
                      verticalCardSpacing),
                  sliver: SliverToBoxAdapter(
                      child: _buildWeeklyProgressSection(
                          weekRangeText, // Now defined
                          completedThisWeek,
                          totalPlannedWorkouts,
                          weeklyProgress,
                          headerFontSize,
                          subHeaderFontSize,
                          isDesktop,
                          isTablet)),
                ),

              if (!_isLoadingWorkouts && _recentWorkouts.isNotEmpty)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: _buildRecentActivitySection(
                      _recentWorkouts,
                      cardTitleFontSize,
                      subHeaderFontSize,
                      verticalCardSpacing),
                ),

              if (!_isLoadingWorkouts &&
                  _upcomingWorkouts.isEmpty &&
                  _recentWorkouts.isEmpty)
                SliverFillRemaining(
                  // Use SliverFillRemaining to center content if list is empty
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.fitness_center_outlined,
                              size: 60, color: textWhite54),
                          const SizedBox(height: 16),
                          Text(
                            "No workouts scheduled or completed recently.\nPlan your next session!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: textWhite70,
                                fontSize: subHeaderFontSize),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                  child:
                      SizedBox(height: verticalCardSpacing)), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(String name, String? profileImageUrl, double headerFs,
      double subHeaderFs, bool isDesktop, bool isTablet) {
    return Row(
      children: [
        CircleAvatar(
          radius: isDesktop ? 32 : (isTablet ? 28 : 24),
          backgroundColor: cardBlue,
          backgroundImage:
              (profileImageUrl != null && profileImageUrl.isNotEmpty)
                  ? NetworkImage(profileImageUrl)
                  : null,
          onBackgroundImageError:
              profileImageUrl != null && profileImageUrl.isNotEmpty
                  ? (_, __) {}
                  : null, // Basic error handling
          child: (profileImageUrl == null || profileImageUrl.isEmpty)
              ? Icon(Icons.person,
                  size: isDesktop ? 36 : (isTablet ? 32 : 28),
                  color: textWhite70)
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome,',
                style: GoogleFonts.poppins(
                    color: textWhite70, fontSize: subHeaderFs * 0.9),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: GoogleFonts.poppins(
                    color: textWhite,
                    fontSize: headerFs,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.notifications_none_outlined,
              color: textWhite70, size: isDesktop ? 28 : 24),
          onPressed: () {/* TODO: Navigate to notifications */},
        ),
      ],
    );
  }

  Widget _buildTodaysRoutineCard(
      Workout workout, double titleFs, double subFs, double vSpacing) {
    return Card(
      elevation: 4,
      color: cardBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(vSpacing * 0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Focus",
              style: GoogleFonts.poppins(
                  color: textWhite,
                  fontSize: titleFs,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: vSpacing * 0.5),
            Text(
              workout.name,
              style: GoogleFonts.poppins(
                  color: accentColor,
                  fontSize: titleFs * 0.9,
                  fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: vSpacing * 0.3),
            Row(
              children: [
                Icon(Icons.timer_outlined, color: textWhite70, size: subFs),
                const SizedBox(width: 8),
                Text(
                  "${workout.duration} min", // Assuming duration is in minutes
                  style:
                      GoogleFonts.poppins(color: textWhite70, fontSize: subFs),
                ),
                const SizedBox(width: 16),
                Icon(Icons.category_outlined, color: textWhite70, size: subFs),
                const SizedBox(width: 8),
                Text(
                  workout.type,
                  style:
                      GoogleFonts.poppins(color: textWhite70, fontSize: subFs),
                ),
              ],
            ),
            SizedBox(height: vSpacing * 0.7),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow_rounded,
                    color: darkBackgroundBlue),
                label: Text(
                  'Start Workout',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: darkBackgroundBlue),
                ),
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutDetailScreen(workoutId: workout.id)));
                  print("Start workout: ${workout.id}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: EdgeInsets.symmetric(vertical: vSpacing * 0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgressSection(
      String weekRange,
      int completed,
      int total,
      double progress,
      double headerFs,
      double subFs,
      bool isDesktop,
      bool isTablet) {
    return Card(
      elevation: 4,
      color: cardBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weekly Progress',
                        style: GoogleFonts.poppins(
                            color: textWhite,
                            fontSize: headerFs * 0.9,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(weekRange,
                        style: GoogleFonts.poppins(
                            color: textWhite70, fontSize: subFs * 0.9)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$completed/$total Done',
                        style: GoogleFonts.poppins(
                            color: accentColor,
                            fontSize: subFs,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: isTablet ? 100 : 80, // Bar width
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor:
                            textWhite.withAlpha((255 * 0.2).round()),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(accentColor),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              // Allow horizontal scroll for day cards
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(7, (index) {
                  final day = _weekDays[index];
                  final isToday = isSameDay(day, _now);
                  final eventsOnDay = _getEventsForCalendarDay(day);
                  final bool hasCompletedWorkout =
                      eventsOnDay.any((w) => w.completed);

                  return Container(
                    width: isTablet ? 65 : 55,
                    margin: EdgeInsets.only(
                        right: index == 6 ? 0 : (isTablet ? 10 : 8)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isToday
                          ? accentColor.withAlpha((255 * 0.9).round())
                          : primaryBlue.withAlpha((255 * 0.5).round()),
                      borderRadius: BorderRadius.circular(12),
                      border: isToday
                          ? Border.all(color: accentColor, width: 2)
                          : null,
                      boxShadow: isToday
                          ? [
                              BoxShadow(
                                  color: accentColor
                                      .withAlpha((255 * 0.3).round()),
                                  blurRadius: 8,
                                  spreadRadius: 1)
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E', 'en_US')
                              .format(day)
                              .substring(0, 1), // Just "M", "T", "W"
                          style: GoogleFonts.poppins(
                            color: isToday ? darkBackgroundBlue : textWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: subFs * 0.85,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${day.day}',
                          style: GoogleFonts.poppins(
                            color: isToday ? darkBackgroundBlue : textWhite,
                            fontWeight:
                                isToday ? FontWeight.bold : FontWeight.w600,
                            fontSize: subFs * 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (eventsOnDay.isNotEmpty)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: hasCompletedWorkout
                                  ? Colors.white
                                  : Colors
                                      .amberAccent, // Different color if completed
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          const SizedBox(
                              height: 8), // Placeholder for alignment
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection(List<Workout> recentWorkouts,
      double titleFs, double subFs, double verticalCardSpacing) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: EdgeInsets.only(
              top: verticalCardSpacing *
                  0.5), // Now verticalCardSpacing is in scope
          child: Text(
            'Recent Activities',
            style: GoogleFonts.poppins(
                color: textWhite,
                fontSize: titleFs,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        ...recentWorkouts.take(3).map((workout) {
          // Show max 3 recent
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 6),
            color: cardBlue.withAlpha((255 * 0.9).round()),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryBlue.withAlpha((255 * 0.7).round()),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _getWorkoutTypeIcon(workout.type), // Helper for icon
              ),
              title: Text(
                workout.name,
                style: GoogleFonts.poppins(
                    color: textWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: subFs * 1.1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "${DateFormat('MMM d, yyyy').format(workout.scheduledDate)} • ${workout.duration} min",
                style: GoogleFonts.poppins(
                    color: textWhite70, fontSize: subFs * 0.9),
              ),
              trailing: workout.completed
                  ? const Icon(Icons.check_circle, color: accentColor, size: 22)
                  : const Icon(Icons.pending_outlined,
                      color: textWhite54, size: 22),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutDetailScreen(workoutId: workout.id)));
                print("Navigate to recent workout: ${workout.id}");
              },
            ),
          );
        }).toList(),
      ]),
    );
  }

  Icon _getWorkoutTypeIcon(String type) {
    // Example: map workout type to an icon
    switch (type.toLowerCase()) {
      case 'strength':
        return const Icon(Icons.fitness_center, color: textWhite, size: 24);
      case 'cardio':
        return const Icon(Icons.directions_run, color: textWhite, size: 24);
      case 'flexibility':
      case 'yoga':
        return const Icon(Icons.self_improvement, color: textWhite, size: 24);
      default:
        return const Icon(Icons.sports_gymnastics, color: textWhite, size: 24);
    }
  }

  // Helper method to check if two DateTime objects represent the same day.
  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

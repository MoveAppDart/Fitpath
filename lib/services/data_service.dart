import 'package:flutter/material.dart';

class DataService {
  // User profile data
  static Map<String, dynamic> getUserProfile() {
    return {
      'name': 'Usuario de Prueba',
      'email': 'usuario@example.com',
      'profileImage': 'assets/profile.jpg',
      'memberSince': 'Mayo 2025',
      'height': '170 cm',
      'weight': '65 kg',
      'age': 25,
    };
  }

  // Workout collections data
  static List<Map<String, dynamic>> getWorkoutCollections() {
    return [
      {
        'name': 'Upper Body',
        'exercises': 8,
        'duration': '45 min',
        'color': const Color(0xFF4A90E2),
      },
      {
        'name': 'Lower Body',
        'exercises': 6,
        'duration': '40 min',
        'color': const Color(0xFFE2844A),
      },
      {
        'name': 'Full Body',
        'exercises': 12,
        'duration': '60 min',
        'color': const Color(0xFF50E24A),
      },
      {
        'name': 'Core Strength',
        'exercises': 5,
        'duration': '30 min',
        'color': const Color(0xFFE24A98),
      },
    ];
  }

  // Exercise data for workout detail
  static List<Map<String, dynamic>> getExercisesForWorkout(String workoutName) {
    final Map<String, List<Map<String, dynamic>>> workoutExercises = {
      'Upper Body': [
        {
          'name': 'Bench Press',
          'sets': 3,
          'reps': 12,
          'weight': '60 kg',
          'image': 'assets/bench_press.jpg',
          'instructions': [
            'Lie on a flat bench with your feet flat on the floor',
            'Grip the barbell with hands slightly wider than shoulder-width',
            'Lower the bar to your mid-chest',
            'Press the bar back up to the starting position',
          ],
        },
        {
          'name': 'Pull-ups',
          'sets': 3,
          'reps': 8,
          'weight': 'Body weight',
          'image': 'assets/pullups.jpg',
          'instructions': [
            'Hang from a pull-up bar with hands shoulder-width apart',
            'Pull your body up until your chin is above the bar',
            'Lower yourself back down with control',
          ],
        },
        {
          'name': 'Shoulder Press',
          'sets': 3,
          'reps': 10,
          'weight': '40 kg',
          'image': 'assets/shoulder_press.jpg',
          'instructions': [
            'Sit on a bench with back support',
            'Hold dumbbells at shoulder height with palms facing forward',
            'Press the weights upward until arms are extended',
            'Lower the weights back to shoulder level',
          ],
        },
      ],
      'Lower Body': [
        {
          'name': 'Squats',
          'sets': 4,
          'reps': 12,
          'weight': '80 kg',
          'image': 'assets/squats.jpg',
          'instructions': [
            'Stand with feet shoulder-width apart',
            'Lower your body as if sitting in a chair',
            'Keep your back straight and knees over toes',
            'Return to standing position',
          ],
        },
        {
          'name': 'Deadlifts',
          'sets': 3,
          'reps': 8,
          'weight': '100 kg',
          'image': 'assets/deadlifts.jpg',
          'instructions': [
            'Stand with feet hip-width apart',
            'Bend at hips and knees to grip barbell',
            'Keep back straight and lift by extending hips and knees',
            'Return weight to floor with controlled movement',
          ],
        },
      ],
      'Full Body': [
        {
          'name': 'Burpees',
          'sets': 3,
          'reps': 15,
          'weight': 'Body weight',
          'image': 'assets/burpees.jpg',
          'instructions': [
            'Start in a standing position',
            'Move into a squat position with hands on the ground',
            'Kick feet back into a plank position',
            'Return feet to squat position',
            'Jump up from squat position',
          ],
        },
        {
          'name': 'Mountain Climbers',
          'sets': 3,
          'reps': '30 seconds',
          'weight': 'Body weight',
          'image': 'assets/mountain_climbers.jpg',
          'instructions': [
            'Start in a plank position',
            'Drive one knee toward your chest',
            'Quickly switch legs, extending the bent leg back to plank',
            'Continue alternating legs at a rapid pace',
          ],
        },
      ],
      'Core Strength': [
        {
          'name': 'Plank',
          'sets': 3,
          'reps': '60 seconds',
          'weight': 'Body weight',
          'image': 'assets/plank.jpg',
          'instructions': [
            'Start in a forearm plank position',
            'Engage your core and glutes',
            'Keep your body in a straight line from head to heels',
            'Hold the position for the prescribed time',
          ],
        },
        {
          'name': 'Russian Twists',
          'sets': 3,
          'reps': 20,
          'weight': '5 kg',
          'image': 'assets/russian_twists.jpg',
          'instructions': [
            'Sit on the floor with knees bent',
            'Lean back slightly, keeping your back straight',
            'Hold weight with both hands and twist to one side',
            'Twist to the opposite side to complete one rep',
          ],
        },
      ],
    };

    return workoutExercises[workoutName] ?? [];
  }

  // Calendar workout history
  static Map<DateTime, List<String>> getWorkoutHistory() {
    final now = DateTime.now();
    return {
      DateTime(now.year, now.month, now.day - 2): ['Upper Body', '45 min'],
      DateTime(now.year, now.month, now.day - 4): ['Lower Body', '40 min'],
      DateTime(now.year, now.month, now.day - 7): ['Full Body', '60 min'],
      DateTime(now.year, now.month, now.day - 9): ['Core Strength', '30 min'],
      DateTime(now.year, now.month, now.day - 11): ['Upper Body', '45 min'],
      DateTime(now.year, now.month, now.day - 14): ['Lower Body', '40 min'],
    };
  }

  // Stats data
  static Map<String, dynamic> getStatsData() {
    return {
      'exerciseStats': {
        7: {
          'Bench Press': '12%', 'Pull-ups': '10%', 'Shoulder Press': '8%', 
          'Squats': '15%', 'Deadlifts': '12%', 'Lunges': '8%',
          'Bicep Curls': '10%', 'Tricep Extensions': '9%',
        },
        15: {
          'Bench Press': '15%', 'Pull-ups': '12%', 'Shoulder Press': '10%', 
          'Squats': '18%', 'Deadlifts': '14%', 'Lunges': '9%',
          'Bicep Curls': '12%', 'Tricep Extensions': '10%',
        },
        30: {
          'Bench Press': '18%', 'Pull-ups': '15%', 'Shoulder Press': '12%', 
          'Squats': '20%', 'Deadlifts': '16%', 'Lunges': '10%',
          'Bicep Curls': '14%', 'Tricep Extensions': '12%',
        },
      },
      'regionStats': {
        7: {'Arms': '25%', 'Back': '20%', 'Chest': '20%', 'Legs': '35%'},
        15: {'Arms': '30%', 'Back': '25%', 'Chest': '20%', 'Legs': '25%'},
        30: {'Arms': '35%', 'Back': '25%', 'Chest': '25%', 'Legs': '15%'},
      },
      'progressData': {
        'weight': [76, 76.5, 77, 77.5, 78, 78.2, 78.5],
        'benchPress': [50, 52.5, 55, 57.5, 60, 62.5, 65],
        'squats': [70, 72.5, 75, 77.5, 80, 82.5, 85],
      }
    };
  }

  // Integration options
  static List<Map<String, dynamic>> getIntegrationOptions() {
    return [
      {
        'name': 'Fitbit',
        'icon': Icons.fitness_center,
        'isConnected': true,
      },
      {
        'name': 'Apple Health',
        'icon': Icons.favorite,
        'isConnected': false,
      },
      {
        'name': 'Google Fit',
        'icon': Icons.directions_run,
        'isConnected': false,
      },
      {
        'name': 'Samsung Health',
        'icon': Icons.health_and_safety,
        'isConnected': false,
      },
    ];
  }

  // Recent workouts for home screen
  static List<Map<String, dynamic>> getRecentWorkouts() {
    return [
      {
        'name': 'Upper Body',
        'date': 'Yesterday',
        'duration': '45 min',
        'completed': true,
      },
      {
        'name': 'Lower Body',
        'date': '3 days ago',
        'duration': '40 min',
        'completed': true,
      },
      {
        'name': 'Full Body',
        'date': '6 days ago',
        'duration': '60 min',
        'completed': true,
      },
    ];
  }

  // Upcoming workouts for home screen
  static List<Map<String, dynamic>> getUpcomingWorkouts() {
    return [
      {
        'name': 'Core Strength',
        'date': 'Today',
        'time': '18:00',
        'duration': '30 min',
      },
      {
        'name': 'Upper Body',
        'date': 'Tomorrow',
        'time': '17:30',
        'duration': '45 min',
      },
      {
        'name': 'Lower Body',
        'date': 'In 3 days',
        'time': '18:00',
        'duration': '40 min',
      },
    ];
  }

  // User achievements
  static List<Map<String, dynamic>> getUserAchievements() {
    return [
      {
        'title': 'First Workout',
        'description': 'Completed your first workout',
        'icon': Icons.fitness_center,
        'date': '2023-03-15',
        'unlocked': true,
      },
      {
        'title': 'Consistency King',
        'description': 'Worked out 7 days in a row',
        'icon': Icons.calendar_today,
        'date': '2023-04-22',
        'unlocked': true,
      },
      {
        'title': 'Strength Milestone',
        'description': 'Bench pressed 100kg',
        'icon': Icons.trending_up,
        'date': '2023-06-10',
        'unlocked': false,
      },
      {
        'title': 'Marathon Runner',
        'description': 'Ran 10km in under 50 minutes',
        'icon': Icons.directions_run,
        'date': null,
        'unlocked': false,
      },
    ];
  }

  // Nutrition data
  static Map<String, dynamic> getNutritionData() {
    return {
      'calories': {
        'goal': 2500,
        'consumed': 1850,
        'burned': 450,
      },
      'macros': {
        'protein': {'goal': 180, 'consumed': 145},
        'carbs': {'goal': 250, 'consumed': 180},
        'fat': {'goal': 80, 'consumed': 65},
      },
      'water': {
        'goal': 3000, // ml
        'consumed': 2100, // ml
      },
      'meals': [
        {
          'name': 'Breakfast',
          'time': '08:30',
          'calories': 450,
          'items': ['Oatmeal with berries', 'Protein shake', 'Coffee'],
        },
        {
          'name': 'Lunch',
          'time': '13:00',
          'calories': 650,
          'items': ['Grilled chicken salad', 'Whole grain bread', 'Apple'],
        },
        {
          'name': 'Snack',
          'time': '16:00',
          'calories': 200,
          'items': ['Greek yogurt', 'Almonds'],
        },
        {
          'name': 'Dinner',
          'time': '19:30',
          'calories': 550,
          'items': ['Salmon', 'Brown rice', 'Steamed vegetables'],
        },
      ],
    };
  }
}
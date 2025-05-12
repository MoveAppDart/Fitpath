import 'package:flutter/material.dart';
import 'exercise_execution_screen.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String workoutName;
  
  const WorkoutDetailScreen({
    super.key, 
    required this.workoutName,
  });

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  Widget build(BuildContext context) {
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
              children: [
                // Header with title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.workoutName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Exercise list
                Expanded(
                  child: ListView.builder(
                    itemCount: 4, // Sample data
                    itemBuilder: (context, index) {
                      return _buildExerciseCard(
                        exerciseName: "Bent Over Row",
                        sets: "4 sets",
                        imageAsset: "assets/exercise_${index + 1}.png",
                      );
                    },
                  ),
                ),
                
                // Bottom buttons
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseExecutionScreen(
                                exerciseName: "Thrust and Reach",
                                imageAsset: "assets/exercise_1.png",
                                instructions: [
                                  "Starting position: Stand with feet shoulder-width apart, hold dumbbells at shoulder height with palms facing forward and activate core to maintain a stable posture.",
                                  "Push movement: Extend arms upward, pushing dumbbells until elbows are almost extended, maintaining control at the top of the movement.",
                                  "Lowering phase: Lower the dumbbells slowly to the starting position, slightly bending the elbows and controlling the movement to maintain muscle tension."
                                ],
                                reps: 12,
                                weight: "40kg",
                                totalSets: 3,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Start',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24, 
                          vertical: 16
                        ),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildExerciseCard({
    required String exerciseName,
    required String sets,
    required String imageAsset,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise name and sets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exerciseName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                sets,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Exercise image
          Row(
            children: [
              Image.asset(
                imageAsset,
                height: 60,
                width: 60,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Sets and reps
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A7CCA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      '10 x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '30kg',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
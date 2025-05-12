import 'package:flutter/material.dart';
import 'dart:async';

class ExerciseExecutionScreen extends StatefulWidget {
  final String exerciseName;
  final String imageAsset;
  final List<String> instructions;
  final int reps;
  final String weight;
  final int totalSets;

  const ExerciseExecutionScreen({
    super.key,
    required this.exerciseName,
    required this.imageAsset,
    required this.instructions,
    required this.reps,
    required this.weight,
    required this.totalSets,
  });

  @override
  _ExerciseExecutionScreenState createState() => _ExerciseExecutionScreenState();
}

class _ExerciseExecutionScreenState extends State<ExerciseExecutionScreen> {
  int _seconds = 0;
  int _currentSet = 1;
  bool _isRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _pauseTimer() {
    _isRunning = false;
    _timer?.cancel();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _pauseTimer();
    } else {
      _startTimer();
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.exerciseName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Exercise image
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.imageAsset,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              // Instructions
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E4F0), // Light blue background
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Instructions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF003366), // Navy blue
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20, color: Color(0xFF003366)),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      widget.instructions.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}. ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2), // Blue text
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.instructions[index],
                                style: const TextStyle(
                                  color: Color(0xFF1976D2), // Blue text
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Exercise info and timer
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFD6E4F0), // Light blue background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Navy blue header with white line
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF003366), // Navy blue
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Exercise info
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Reps and weight
                          Center(
                            child: Text(
                              '${widget.reps} reps\n${widget.weight}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 2),
                          
                          // Total and Sets
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      color: Color(0xFF00796B), 
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    _formatTime(_seconds),
                                    style: const TextStyle(
                                      color: Color(0xFF00796B),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Sets',
                                    style: TextStyle(
                                      color: Color(0xFF00796B),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '$_currentSet/${widget.totalSets}',
                                    style: const TextStyle(
                                      color: Color(0xFF00796B),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Timer
                          Text(
                            _formatTime(_seconds),
                            style: const TextStyle(
                              color: Color(0xFF00796B),
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: _currentSet / widget.totalSets,
                              backgroundColor: const Color(0xFFE0F2F1), // Light teal
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF80CBC4)), // Medium teal
                              minHeight: 8,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Control buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (_currentSet > 1) {
                                    setState(() {
                                      _currentSet--;
                                    });
                                  }
                                },
                                child: const Text(
                                  'Prev',
                                  style: TextStyle(color: Color(0xFF00796B)),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF00796B), width: 2),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _isRunning ? Icons.pause : Icons.play_arrow,
                                    color: const Color(0xFF00796B),
                                  ),
                                  onPressed: _toggleTimer,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_currentSet < widget.totalSets) {
                                    setState(() {
                                      _currentSet++;
                                    });
                                  }
                                },
                                child: const Text(
                                  'Next',
                                  style: TextStyle(color: Color(0xFF00796B)),
                                ),
                              ),
                            ],
                          ),
                        ],
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
}
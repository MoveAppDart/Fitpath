import 'package:flutter/material.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  // Track selected days
  final Set<String> _selectedDays = {};
  final List<String> _days = ['dl.', 'dt.', 'dc.', 'dj.', 'dv.', 'ds.', 'dg.'];
  
  // Training time options
  final List<String> _trainingTimes = ['15 min', '30 min', '45 min', '60 min', '90 min'];
  String _selectedTrainingTime = '30 min';
  
  // Plan period options
  final List<String> _planPeriods = ['4 weeks', '8 weeks', '12 weeks', '16 weeks'];
  String _selectedPlanPeriod = '8 weeks';
  
  // Add this property to track selected activity
  String? _selectedActivity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005DC8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create a plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Program',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Days selector
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6E4F0), // Light blue background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _days.map((day) => _buildDayCircle(day)).toList(),
                          ),
                          const SizedBox(height: 16),
                          _buildTimeSelector('Average training time', _selectedTrainingTime, _trainingTimes),
                          const SizedBox(height: 8),
                          _buildTimeSelector('Plan period', _selectedPlanPeriod, _planPeriods),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    const Text(
                      'What type of activity would you like to do?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Activity options
                    _buildActivityOption(
                      'Cardiovascular',
                      'Goal: Improve endurance, heart health, and burn calories.',
                      isSelected: _selectedActivity == 'Cardiovascular',
                      onTap: () => setState(() => _selectedActivity = 'Cardiovascular'),
                    ),
                    const SizedBox(height: 12),
                    _buildActivityOption(
                      'Strength Training',
                      'Goal: Build strength, tone muscles, and improve bone density.',
                      isSelected: _selectedActivity == 'Strength Training',
                      onTap: () => setState(() => _selectedActivity = 'Strength Training'),
                    ),
                    const SizedBox(height: 12),
                    _buildActivityOption(
                      'Yoga and Pilates',
                      'Goal: Enhance flexibility, core strength, and relaxation.',
                      isSelected: _selectedActivity == 'Yoga and Pilates',
                      onTap: () => setState(() => _selectedActivity = 'Yoga and Pilates'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(String label, String currentValue, List<String> options) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF757575),
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            _showOptionsDialog(label, currentValue, options);
          },
          child: Row(
            children: [
              Text(
                currentValue,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF757575),
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _showOptionsDialog(String title, String currentValue, List<String> options) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.minPositive,
            height: 250,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(options[index]),
                  selected: options[index] == currentValue,
                  onTap: () {
                    setState(() {
                      if (title == 'Average training time') {
                        _selectedTrainingTime = options[index];
                      } else if (title == 'Plan period') {
                        _selectedPlanPeriod = options[index];
                      }
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayCircle(String day) {
    final bool isSelected = _selectedDays.contains(day);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDays.remove(day);
          } else {
            _selectedDays.add(day);
          }
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent, // Green when selected
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF757575),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityOption(String title, String description, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
                ? const Color(0xFF1A4B94) // Darker blue when selected
                : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
                ? Border.all(color: Colors.white.withOpacity(0.3), width: 2)
                : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF005DC8),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with user info and notification
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nice to see you again,',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            'John Marcus',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Today's routine card
                Card(
                  color: Colors.white.withOpacity(0.15),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's routine",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.3),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            ),
                            child: Text('Start', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // My workouts button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B4E71),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('My workouts', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),

                // Weekly schedule section
                Card(
                  color: Colors.white.withOpacity(0.15),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly schedule',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (var i = 0; i < 7; i++)
                              Column(
                                children: [
                                  Text(
                                    '${10 + i}',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i],
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                  if (i < 3)
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Progress of the week',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'Just 1 workout more!',
                                  style: TextStyle(color: Colors.white60, fontSize: 12),
                                ),
                              ],
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: 0.75,
                                  backgroundColor: Colors.white24,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                                Text(
                                  '3/4',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Health Care section
                Text(
                  'Health Care',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.white.withOpacity(0.15),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Icon(Icons.fitness_center, color: Colors.white),
                            Text(
                              '450',
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            ),
                            Text(
                              'kcal',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sleep Time',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Goal is 8 hours',
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 8),
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  LinearProgressIndicator(
                                    value: 0.75,
                                    backgroundColor: Colors.white24,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '7:30 h',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

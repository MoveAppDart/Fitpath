import 'package:flutter/material.dart';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context){
    dynamic size, heights, width;
    size = MediaQuery.of(context).size;
    heights = size.height;
    width = size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 0, 93, 200),
              Color.fromARGB(255, 1, 69, 148),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Profile Section
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                SizedBox(height: 16),
                Text(
                  'John Marcus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'john.marcus@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 40),

                // Menu Items
                ListTile(
                  leading: Icon(Icons.person, color: Colors.white),
                  title: Text('Profile', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {},
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading: Icon(Icons.language, color: Colors.white),
                  title: Text('Language', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {},
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading: Icon(Icons.integration_instructions, color: Colors.white),
                  title: Text('Integrations', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {},
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.white),
                  title: Text('Settings', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {},
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: Text('Log Out', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
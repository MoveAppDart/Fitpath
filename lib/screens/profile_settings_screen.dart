import 'package:flutter/material.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor:
            const Color.fromARGB(255, 0, 93, 200), // Match top gradient color
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
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
                // Add your profile settings widgets here
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('Edit Profile',
                      style: TextStyle(color: Colors.white)),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {},
                ),
                const Divider(color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.white),
                  title: const Text('Change Email',
                      style: TextStyle(color: Colors.white)),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {},
                ),
                const Divider(color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.lock, color: Colors.white),
                  title: const Text('Change Password',
                      style: TextStyle(color: Colors.white)),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
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

import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 200), // Match top gradient color
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
                Text(
                  LocalizationService.getTranslatedValue(context, 'settings'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.white),
                  title: const Text('Notifications', style: TextStyle(color: Colors.white)),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                    activeColor: Colors.white,
                  ),
                  onTap: () {},
                ),
                const Divider(color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.dark_mode, color: Colors.white),
                  title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                    activeColor: Colors.white,
                  ),
                  onTap: () {},
                ),
                const Divider(color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.privacy_tip, color: Colors.white),
                  title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
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
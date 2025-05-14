import 'package:flutter/material.dart';
import 'dart:ui';
import 'login_screen.dart';
import 'profile_settings_screen.dart';
import 'app_settings_screen.dart';
import '../services/localization_service.dart';
import '../services/data_service.dart';  // Add this import

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'English';  // Add this variable declaration

  // Move dialog methods here, outside build()
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 1, 69, 148),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Language',  // Use a simple string instead of LocalizationService
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLanguageOption(context, 'English', _selectedLanguage == 'English'),  // Updated
                const Divider(color: Colors.white24),
                _buildLanguageOption(context, 'Spanish', _selectedLanguage == 'Spanish'),  // Updated
                const Divider(color: Colors.white24),
                _buildLanguageOption(context, 'French', _selectedLanguage == 'French'),  // Updated
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language, bool isSelected) {
    return ListTile(
      title: Text(
        language,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: _selectedLanguage == language  // Modified this line
          ? const Icon(Icons.check, color: Colors.white)
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;  // Add this line
        });
        Navigator.pop(context);
        // You can add your localization logic here
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get user data from DataService
    final userData = DataService.getUserProfile();
    
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
                // Profile Section - Using Icon instead of missing image
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  userData['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['email'],
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 40),
                
                // Menu Items
                ListTile(
                  leading: Icon(Icons.person, color: Colors.white),
                  title: const Text('Profile', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingsScreen())),
                ),
                Divider(color: Colors.white24),
                // Add this method to _ProfileScreenState class
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.white),
                  title: const Text('Language', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () => _showLanguageDialog(context),  // Add this
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading: Icon(Icons.integration_instructions, color: Colors.white),
                  title: Text('Integrations', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {
                  },
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.white),
                  title: Text('Settings', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppSettingsScreen())),
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: Text('Log Out', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
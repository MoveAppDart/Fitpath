import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

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
                  'Select Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLanguageOption(context, 'English', true),
                const Divider(color: Colors.white24),
                _buildLanguageOption(context, 'Spanish', false),
                const Divider(color: Colors.white24),
                _buildLanguageOption(context, 'French', false),
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
      trailing: isSelected
          ? const Icon(Icons.check, color: Colors.white)
          : null,
      onTap: () {
        Navigator.pop(context);
        // Add language change logic here
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
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
                const Text(
                  'Language Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.white),
                  title: const Text('Change Language', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () => _showLanguageDialog(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
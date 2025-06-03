import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

// Adjust import paths as per your project structure
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import './login_screen.dart';
import './profile_settings_screen.dart';
import './app_settings_screen.dart';
import '../models/user.dart'; // Import User model if needed for type casting
// Import Profile model if needed for type casting

class ProfileScreen extends StatefulWidget {
  // Added const constructor as it's good practice if no parameters are passed
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'English';
  bool _isLoading = false;
  String? _errorMessage;

  // Theme Colors
  static const Color primaryBlue = Color(0xFF005DC8);
  static const Color darkBlueCanvas = Color(0xFF003366);
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;
  // static const Color textWhite54 = Colors.white54; // Not used directly, can be removed or kept for future
  static const Color accentColor = Color(0xFF4CAF50);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Ensure UserProvider is available before calling methods on it
    // This is usually handled by how providers are set up in main.dart or a higher widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData(); // Load user data after the first frame
    });
    _loadPreferredLanguage(); // Language can be loaded immediately
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserProfile();

      if (userProvider.error != null && mounted) {
        setState(() {
          _errorMessage = userProvider.error;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading profile data: ${e.toString()}';
        });
      }
      print('ProfileScreen: Error loading user data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPreferredLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('preferred_language');
      if (savedLanguage != null && mounted) {
        setState(() {
          _selectedLanguage = savedLanguage;
        });
      }
    } catch (e) {
      print('ProfileScreen: Error loading language preference: $e');
    }
  }

  Future<void> _savePreferredLanguage(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('preferred_language', language);
      if (mounted) {
        setState(() {
          _selectedLanguage = language;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language changed to $language')),
        );
        // TODO: Implement actual language change logic (e.g., using a Localization provider)
        print(
            'Language preference saved: $language. App restart might be needed for full effect.');
      }
    } catch (e) {
      print('ProfileScreen: Error saving language preference: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save language preference.')),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: primaryBlue.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Language',
                  style: GoogleFonts.poppins(
                    color: textWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                // Need a StatefulWidget or StatefulBuilder inside the dialog if _selectedLanguage
                // for the dialog needs to be managed independently and reactively within the dialog itself.
                // For simplicity, we are using the _ProfileScreenState's _selectedLanguage for comparison.
                _buildLanguageOption(
                    dialogContext, 'English', _selectedLanguage == 'English'),
                const Divider(color: Colors.white24, height: 1),
                _buildLanguageOption(
                    dialogContext, 'Spanish', _selectedLanguage == 'Spanish'),
                const Divider(color: Colors.white24, height: 1),
                _buildLanguageOption(
                    dialogContext, 'French', _selectedLanguage == 'French'),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text('Cancel',
                        style: GoogleFonts.poppins(color: textWhite70)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
      BuildContext dialogContext, String language, bool isSelected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        language,
        style: GoogleFonts.poppins(color: textWhite, fontSize: 16),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: accentColor)
          : const Icon(Icons.circle_outlined,
              color: Colors.white54), // CORRECTION: Used Colors.white54
      onTap: () {
        Navigator.of(dialogContext).pop();
        _savePreferredLanguage(language);
      },
    );
  }

  Widget _buildProfileHeader(UserProvider userProvider, double screenWidth) {
    final User? user = userProvider.user; // Get the User object
    // final Profile? profile = userProvider.profile; // Get the Profile object if you need it

    Widget profileAvatar = CircleAvatar(
      radius: screenWidth * 0.12,
      backgroundColor: Colors.white24,
      child: Icon(
        Icons.person,
        size: screenWidth * 0.1,
        color: textWhite,
      ),
    );

    // Prioritize User.profilePicture
    if (user?.profilePicture != null && user!.profilePicture!.isNotEmpty) {
      profileAvatar = CircleAvatar(
        radius: screenWidth * 0.12,
        backgroundImage: NetworkImage(user.profilePicture!),
        onBackgroundImageError: (exception, stackTrace) {
          print('Error loading profile image: $exception');
          // Optionally set state to show placeholder, though it might already fallback
        },
      );
    }
    // CORRECTION: Removed the logic for profile.profilePictureUrl as per assumption
    // If you do have profilePictureUrl in your Profile model, you can re-add it as a fallback:
    // else if (profile?.profilePictureUrl != null && profile!.profilePictureUrl!.isNotEmpty) {
    //    profileAvatar = CircleAvatar(
    //     radius: screenWidth * 0.12,
    //     backgroundImage: NetworkImage(profile.profilePictureUrl!),
    //   );
    // }

    return Column(
      children: [
        profileAvatar,
        const SizedBox(height: 16),
        Text(
          user?.name ?? 'FitPath User',
          style: GoogleFonts.poppins(
            color: textWhite,
            fontSize: (screenWidth * 0.06).clamp(20.0, 28.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? 'user@example.com',
          style: GoogleFonts.poppins(
            color: textWhite70,
            fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = textWhite, // Default to textWhite
    bool hasDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor, size: 26),
          title: Text(
            title,
            style: GoogleFonts.poppins(
                color: textWhite, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios, color: textWhite70, size: 16),
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        if (hasDivider)
          const Divider(color: Colors.white24, height: 1, thickness: 0.5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: darkBlueCanvas,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
              color: textWhite, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primaryBlue, darkBlueCanvas],
              stops: [0.0, 0.7]),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: textWhite))
              : _errorMessage != null
                  ? _buildErrorView(screenWidth)
                  : RefreshIndicator(
                      onRefresh: _loadUserData,
                      color: textWhite,
                      backgroundColor: primaryBlue,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        children: [
                          _buildProfileHeader(userProvider, screenWidth),
                          const SizedBox(height: 30),
                          _buildMenuItem(
                            icon: Icons.account_circle_outlined,
                            title: 'Edit Profile',
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfileSettingsScreen(),
                                ),
                              );
                              if (result == true && mounted) {
                                _loadUserData();
                              }
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.language_outlined,
                            title: 'Language',
                            onTap: _showLanguageDialog,
                          ),
                          _buildMenuItem(
                            icon: Icons.link_outlined,
                            title: 'Integrations',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Integrations not yet implemented.')),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: 'App Settings',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AppSettingsScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Help & Support not yet implemented.')),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildMenuItem(
                            icon: Icons.logout,
                            title: 'Log Out',
                            iconColor: Colors.redAccent[100]!,
                            onTap: _handleLogout,
                            hasDivider: false,
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildErrorView(double screenWidth) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.redAccent[100],
              size: screenWidth * 0.15,
            ),
            const SizedBox(height: 20),
            Text(
              _errorMessage ?? 'An unknown error occurred.',
              style: GoogleFonts.poppins(
                  color: textWhite,
                  fontSize: (screenWidth * 0.04).clamp(14.0, 18.0)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh, color: primaryBlue),
              label: Text('Retry',
                  style: GoogleFonts.poppins(
                      color: primaryBlue, fontWeight: FontWeight.w500)),
              onPressed: _loadUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: textWhite,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Placeholders for other screens to make this file runnable independently for testing UI ---
// Remove these or replace with your actual screen imports if they cause conflicts

// class ProfileSettingsScreen extends StatelessWidget {
//   const ProfileSettingsScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar(title: const Text('Edit Profile')), body: const Center(child: Text('Profile Settings Screen')));
//   }
// }

// class AppSettingsScreen extends StatelessWidget {
//   const AppSettingsScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar(title: const Text('App Settings')), body: const Center(child: Text('App Settings Screen')));
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../main.dart' show navigatorKey; // Import navigatorKey
import 'login_screen.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Color accent = Color(0xFF1B3AE5); // Accent color

  Future<void> _completeOnboardingAndNavigate(String routeName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);
      debugPrint("[OnboardingScreen] hasSeenOnboarding set to true.");

      if (mounted) {
        if (routeName == '/login') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else if (routeName == '/register') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignupScreen()),
          );
        }
      }
    } catch (e) {
      debugPrint("[OnboardingScreen] Error in _completeOnboardingAndNavigate: $e");
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Perform navigation checks after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Ensure widget is still in the tree

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentRouteName = ModalRoute.of(context)?.settings.name;
      debugPrint(
          "[OnboardingScreen] didChangeDependencies: isLoggedIn=${authProvider.isLoggedIn}, " "isNewlyRegistered=${userProvider.isNewlyRegistered}, currentRoute=$currentRouteName");

      if (authProvider.isLoggedIn) {
        if (userProvider.isNewlyRegistered) {
          debugPrint("[OnboardingScreen] User logged in & newly registered. Navigating to /step1_signup.");
          navigatorKey.currentState?.pushNamedAndRemoveUntil('/step1_signup', (route) => false);
        } else {
          debugPrint("[OnboardingScreen] User logged in & profile complete. Navigating to /home.");
          navigatorKey.currentState?.pushNamedAndRemoveUntil('/home', (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 375;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF005DC8), // 0%
              Color(0xFF014594), // 50%
              Color(0xFF01336D), // 88%
              Color(0xFF022D60), // 100%
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 24 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                // Logo
                CircleAvatar(
                  radius: isSmall ? 40 : 52,
                  backgroundColor: accent.withOpacity(0.1),
                  child: const Icon(Icons.fitness_center, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 24),
                // App Name
                Text(
                  'FitPath',
                  style: GoogleFonts.poppins(
                    fontSize: isSmall ? 32 : 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your journey to a stronger you',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: isSmall ? 14 : 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),

                // Features
                _buildFeature(icon: Icons.bar_chart, title: 'Track Progress', subtitle: 'Monitor your weekly goals'),
                const SizedBox(height: 16),
                _buildFeature(icon: Icons.fitness_center, title: 'Workouts', subtitle: 'Stay consistent with guided plans'),
                const Spacer(),

                // Buttons
                _primaryButton(
                  context,
                  text: 'Log In',
                  onPressed: () => _completeOnboardingAndNavigate('/login'),
                ),
                const SizedBox(height: 12),
                _secondaryButton(
                  context,
                  text: 'Create Account',
                  onPressed: () => _completeOnboardingAndNavigate('/register'),
                ),
                const SizedBox(height: 24),
                Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.15),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(BuildContext context, {
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton(BuildContext context, {
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: accent, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: accent,
          ),
        ),
      ),
    );
  }
}

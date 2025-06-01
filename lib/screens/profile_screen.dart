import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'profile_settings_screen.dart';
import 'app_settings_screen.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'English';
  bool _isLoading = false;
  String? _errorMessage;

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
                  'Select Language', // Use a simple string instead of LocalizationService
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLanguageOption(context, 'English',
                    _selectedLanguage == 'English'), // Updated
                const Divider(color: Colors.white24),
                _buildLanguageOption(context, 'Spanish',
                    _selectedLanguage == 'Spanish'), // Updated
                const Divider(color: Colors.white24),
                _buildLanguageOption(context, 'French',
                    _selectedLanguage == 'French'), // Updated
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String language, bool isSelected) {
    return ListTile(
      title: Text(
        language,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: _selectedLanguage == language
          ? const Icon(Icons.check, color: Colors.white)
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        _savePreferredLanguage(language);
        Navigator.pop(context);
        // Aquí se podría implementar la lógica de cambio de idioma
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Idioma cambiado a $language')),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadPreferredLanguage();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final success = await userProvider.loadUserProfile();
      
      if (!success && mounted) {
        setState(() {
          _errorMessage = userProvider.error ?? 'No se pudo cargar el perfil';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar datos: $e';
        });
      }
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
      print('Error al cargar preferencia de idioma: $e');
    }
  }

  Future<void> _savePreferredLanguage(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('preferred_language', language);
    } catch (e) {
      print('Error al guardar preferencia de idioma: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usar el provider para obtener datos del usuario
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _errorMessage != null
                  ? _buildErrorView()
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
              children: [
                // Profile Section - Using Icon instead of missing image
                userProvider.user?.profilePicture != null && userProvider.user!.profilePicture!.isNotEmpty
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userProvider.user!.profilePicture!),
                      )
                    : CircleAvatar(
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
                  userProvider.user?.name ?? 'Usuario',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userProvider.user?.email ?? 'email@ejemplo.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 40),

                // Menu Items
                ListTile(
                  leading: Icon(Icons.person, color: Colors.white),
                  title: const Text('Profile',
                      style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSettingsScreen(),
                      ),
                    );
                    
                    // Si se actualizó el perfil, recargar los datos
                    if (result == true) {
                      _loadUserData();
                    }
                  },
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.white),
                  title: const Text('Language',
                      style: TextStyle(color: Colors.white)),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () => _showLanguageDialog(context), // Add this
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading:
                      Icon(Icons.integration_instructions, color: Colors.white),
                  title: Text('Integrations',
                      style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {},
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.white),
                  title:
                      Text('Settings', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppSettingsScreen(),
                      ),
                    );
                  },
                ),
                Divider(color: Colors.white24),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: Text('Log Out', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen())),
                ),
              ],
                  ),
                ),
        ),
      ),
      floatingActionButton: _errorMessage != null
          ? FloatingActionButton(
              onPressed: _loadUserData,
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }
  
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Error desconocido',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 0, 93, 200),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

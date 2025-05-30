import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Importaciones de servicios API
import 'services/api/api_client.dart';
import 'services/api/auth_service.dart';
import 'services/api/user_service.dart';
import 'services/api/workout_service.dart';
// Estos servicios se importarán cuando se necesiten
// import 'services/api/stats_service.dart';
// import 'services/api/weight_log_service.dart';

// Importaciones de providers
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/workout_provider.dart';

// Importaciones de pantallas
import 'screens/login_screen.dart';
import 'screens/bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar servicios
    final apiClient = ApiClient();
    final authService = AuthService(apiClient);
    final userService = UserService(apiClient);
    final workoutService = WorkoutService(apiClient);
    // Estos servicios se utilizarán más adelante cuando se implementen sus respectivas funcionalidades
    // final statsService = StatsService(apiClient);
    // final weightLogService = WeightLogService(apiClient);
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(create: (_) => UserProvider(userService)),
        ChangeNotifierProvider(create: (_) => WorkoutProvider(workoutService)),
      ],
      child: MaterialApp(
        title: 'FitPath',
        debugShowCheckedModeBanner: false, 
        theme: ThemeData(
          textTheme: GoogleFonts.istokWebTextTheme(),
          primaryColor: const Color(0xFF005DC8),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF005DC8),
            primary: const Color(0xFF005DC8),
            secondary: const Color(0xFF004AAE),
          ),
        ),
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
          Locale('fr', ''),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            return authProvider.isLoggedIn 
                ? const BottomNavbar() 
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}

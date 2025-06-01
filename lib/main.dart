// Importaciones de paquetes de Flutter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

// Importaciones de servicios API
import 'services/api/api_client.dart';
import 'services/api/auth_service.dart';
import 'services/api/auth_service_impl.dart';
import 'services/api/user_service.dart';
import 'services/api/workout_service.dart';
import 'services/api/wger_service.dart';

// Importaciones de providers
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/wger_exercises_provider.dart';

// Importaciones de pantallas
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/bottom_navbar.dart';

// Clave global para la navegación
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8080', // Replace with your actual API base URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    final storage = const FlutterSecureStorage();
    final apiClient = ApiClient(dio: dio);
    final userService = UserService(apiClient);
    final workoutService = WorkoutService(apiClient);
    final wgerService = WgerService(apiClient);
    
    // Initialize providers
    final userProvider = UserProvider(userService);
    
    // Initialize AuthService with all required dependencies
    final authService = AuthServiceImpl(
      dio: dio, // Pass the Dio instance directly
      storage: storage,
      userProvider: userProvider,
    );
    // Estos servicios se utilizarán más adelante cuando se implementen sus respectivas funcionalidades
    // final statsService = StatsService(apiClient);
    // final weightLogService = WeightLogService(apiClient);

    // Configurar el gestor de errores global
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      // Aquí podrías agregar lógica para reportar errores a un servicio externo
    };

    return MultiProvider(
      providers: [
        // Proporcionar las instancias de servicios
        Provider<ApiClient>.value(value: apiClient),
        Provider<AuthService>.value(value: authService),
        Provider<UserService>.value(value: userService),
        Provider<WorkoutService>.value(value: workoutService),
        Provider<WgerService>.value(value: wgerService),
        
        // Inicializar UserProvider primero ya que AuthProvider depende de él
        ChangeNotifierProvider(
          create: (context) => UserProvider(userService),
        ),
        
        // Inicializar AuthProvider que depende de UserProvider
        ChangeNotifierProxyProvider<UserProvider, AuthProvider>(
          create: (context) => AuthProvider(
            authService,
            Provider.of<UserProvider>(context, listen: false),
          ),
          update: (context, userProvider, previous) {
            return previous ?? AuthProvider(authService, userProvider);
          },
        ),
        
        // Otros providers
        ChangeNotifierProvider(
          create: (context) => WorkoutProvider(workoutService),
        ),
        
        ChangeNotifierProvider(
          create: (context) => WgerExercisesProvider(wgerService),
        ),
      ],
      child: MaterialApp(
        title: 'FitPath',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey, // Clave global para la navegación
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', ''), // Español
          Locale('en', ''), // Inglés
        ],
        locale: const Locale('es', ''), // Establecer español como idioma por defecto
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF00E5FF),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00E5FF),
            secondary: Color(0xFF00B8D4),
            surface: Color(0xFF1D1E33),
            background: Color(0xFF0A0E21),
          ),
          scaffoldBackgroundColor: const Color(0xFF0A0E21),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData.dark().textTheme,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF00E5FF),
              side: const BorderSide(color: Color(0xFF00E5FF), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        theme: ThemeData(
          textTheme: GoogleFonts.istokWebTextTheme(),
          primaryColor: const Color(0xFF005DC8),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF005DC8),
            primary: const Color(0xFF005DC8),
            secondary: const Color(0xFF004AAE),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const BottomNavbar(),
        },
        onGenerateRoute: (settings) {
          // Handle deep linking or unknown routes
          return MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          );
        },
        builder: (context, child) {
          return Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.isLoading) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              // This will handle the auth state for all routes
              if (authProvider.isLoggedIn && ModalRoute.of(context)?.settings.name != '/home') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, '/home');
                });
              } else if (!authProvider.isLoggedIn && 
                        ModalRoute.of(context)?.settings.name != '/' && 
                        ModalRoute.of(context)?.settings.name != '/login') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, '/login');
                });
              }
              
              return child!;
            },
            child: child,
          );
        },
      ),
    );
  }
}

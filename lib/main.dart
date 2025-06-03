// Importaciones de paquetes de Flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importaciones de modelos
import 'models/exercise.dart';

// Importaciones de servicios
import 'config/env_config.dart';
import 'services/api/auth_service_impl.dart';
import 'services/api/user_service.dart';
import 'services/wger_service.dart';
import 'services/api/api_client.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Importaciones de providers
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/signup_flow_provider.dart';
import 'providers/wger_provider.dart';

// Importaciones de pantallas
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/workouts_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/wger_search_screen.dart';
import 'screens/wger_exercise_details_screen.dart';
import 'screens/exercise_execution_screen.dart';

// Importaciones de pantallas de registro
import 'screens/register/step1_signup.dart';
import 'screens/register/step2_signup.dart' as step2;
import 'screens/register/step3_signup.dart' as step3;
import 'screens/register/step4_signup.dart' as step4;
import 'screens/register/step5_signup.dart' as step5;
import 'screens/register/step6_signup.dart' as step6;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar servicios
  const storage = FlutterSecureStorage();
  
  // Configurar Dio con la URL base
  final dio = Dio(BaseOptions(
    baseUrl: EnvConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));2
  
  final apiClient = ApiClient(dio: dio);
  final userService = UserService(apiClient);
  final userProvider = UserProvider(userService);
  final authService = AuthServiceImpl(
    dio: dio,
    storage: storage,
    userProvider: userProvider,
  );
  
  // Agregar logger para depuración
  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      error: true,
      compact: false,
    ));
  }
  final wgerService = WgerService(apiClient);
  final authProvider = AuthProvider(authService, userProvider);
  final wgerProvider = WgerProvider(wgerService);

  runApp(MyApp(
    authProvider: authProvider,
    userProvider: userProvider,
    wgerProvider: wgerProvider,
    navigatorKey: navigatorKey,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.authProvider,
    required this.userProvider,
    required this.wgerProvider,
    required this.navigatorKey,
  });

  final AuthProvider authProvider;
  final UserProvider userProvider;
  final WgerProvider wgerProvider;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Siguiendo la memoria, primero listamos el UserProvider que es dependencia
        ChangeNotifierProvider.value(
          value: userProvider,
        ),
        // Luego el AuthProvider que depende de UserProvider
        ChangeNotifierProvider.value(
          value: authProvider,
        ),
        ChangeNotifierProvider.value(
          value: wgerProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => SignupFlowProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'FitPath',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('es', 'ES'),
            ],
            theme: ThemeData(
              primaryColor: const Color(0xFF005DC8),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF005DC8),
                primary: const Color(0xFF005DC8),
                secondary: const Color(0xFF01E0A9),
              ),
              textTheme: GoogleFonts.poppinsTextTheme(),
              useMaterial3: true,
            ),
            navigatorKey: navigatorKey,
            initialRoute: '/',
            routes: {
              '/': (context) => const OnboardingScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const SignupScreen(),
              '/signup': (context) => const SignupScreen(),
              '/home': (context) => const HomeScreen(),
              '/step1_signup': (context) => const FirstStepSignup(),
              '/step2_signup': (context) => const step2.SecondStepSignup(),
              '/step3_signup': (context) => const step3.ThirdStepSignup(),
              '/step4_signup': (context) =>
                  const step4.FourthStepSignup(weightKg: 70.0),
              '/step5_signup': (context) => const step5.FifthStepSignup(),
              '/step6_signup': (context) => const step6.SixthStepSignup(),
              '/workouts': (context) => const WorkoutsScreen(),
              '/calendar': (context) => const CalendarScreen(),
              '/stats': (context) => const StatsScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/wger_search': (context) => const WgerSearchScreen(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/wger_exercise_details':
                  final exercise = settings.arguments as Exercise?;
                  return MaterialPageRoute(
                    builder: (context) => WgerExerciseDetailsScreen(
                      exercise: exercise ??
                          Exercise(
                            id: '0',
                            name: 'Exercise',
                            type: 'strength',
                            targetMuscle: 'general',
                            description: 'No description available',
                            equipment: [],
                            isPublic: true,
                          ),
                    ),
                  );
                case '/exercise_execution':
                  final args =
                      settings.arguments as Map<String, dynamic>? ?? {};
                  return MaterialPageRoute(
                    builder: (context) => ExerciseExecutionScreen(
                      exerciseName:
                          args['exerciseName'] as String? ?? 'Exercise',
                      imageAsset: args['imageAsset'] as String? ??
                          'assets/images/exercises/default.png',
                      instructions: (args['instructions'] as List<dynamic>?)
                              ?.cast<String>() ??
                          ['No instructions available'],
                      reps: args['reps'] as int? ?? 10,
                      weight: args['weight']?.toString() ?? '0.0',
                      totalSets: args['totalSets'] as int? ?? 3,
                    ),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  );
              }
            },
            builder: (context, child) {
              final currentRoute = ModalRoute.of(context)?.settings.name;
              final isOnAuthenticatedRoute = [
                '/home',
                '/workouts',
                '/calendar',
                '/stats',
                '/profile',
                '/home_screen',
                '/wger_search',
                '/exercise_execution',
                '/wger_exercise_details',
                '/'
              ].any((route) =>
                  currentRoute == route ||
                  (currentRoute?.startsWith(route) ?? false));

              // Verificar el estado de autenticación
              if (authProvider.isLoggedIn) {
                if (!isOnAuthenticatedRoute && currentRoute != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/home', (route) => false);
                  });
                }
              } else {
                final allowedPublicRoutes = [
                  '/onboarding',
                  '/login',
                  '/register'
                ];
                final isOnAllowedRoute = allowedPublicRoutes.any((route) =>
                    currentRoute == route ||
                    (currentRoute?.startsWith(route) ?? false));

                if (!isOnAllowedRoute &&
                    !(currentRoute?.startsWith('/step') ?? false)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    final prefs = await SharedPreferences.getInstance();
                    final hasSeenOnboarding =
                        prefs.getBool('hasSeenOnboarding') ?? false;
                    final targetRoute =
                        hasSeenOnboarding ? '/login' : '/onboarding';

                    debugPrint('[MainBuilder] Redirigiendo a $targetRoute');
                    if (navigatorKey.currentContext != null) {
                      Navigator.of(navigatorKey.currentContext!)
                          .pushNamedAndRemoveUntil(
                              targetRoute, (route) => false);
                    }
                  });
                }
              }
              return child ?? const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

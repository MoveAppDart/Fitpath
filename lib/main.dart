import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/language_screen.dart';
import 'screens/exercise_detail_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'services/api/auth_service_impl.dart';
import 'services/api/user_service.dart';
import 'services/api/api_client.dart';

// API Client
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Services
final authServiceProvider = Provider<AuthServiceImpl>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthServiceImpl(apiClient.dio); // ✅ Accede al Dio interno
});

final userServiceProvider = Provider<UserService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserService(apiClient);
});

// Providers
final userProvider = ChangeNotifierProvider<UserProvider>((ref) {
  final userService = ref.watch(userServiceProvider);
  return UserProvider(userService);
});

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  final authService = ref.watch(authServiceProvider);
  final userProv = ref.read(userProvider.notifier);
  return AuthProvider(authService, userProv);
});

// Colores de la aplicación
class AppColors {
  static const Color primary = Color(0xFF0A7AFF);
  static const Color accent = Color(0xFF00E676);
  static const Color background = Color(0xFF001E3C);
  static const Color card = Color(0xFF003D7A);
  static const Color error = Color(0xFFFF5252);
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;
  static const Color textWhite54 = Colors.white54;
}

// Clave global para navegación
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Inicializar bindings de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Configuración de la UI del sistema
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Configuración de la UI del sistema
  static void configureSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Configurar la UI del sistema
    configureSystemUI();

    final router = GoRouter(
      initialLocation: '/login',
      redirect: (BuildContext context, GoRouterState state) {
        final isLoggedIn = ref.read(authProvider).isLoggedIn;
        final isLoggingIn =
            state.uri.path == '/login' || state.uri.path == '/signup';

        if (!isLoggedIn && !isLoggingIn) return '/login';
        if (isLoggedIn && isLoggingIn) return '/home';

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (BuildContext context, GoRouterState state) =>
              const SignupScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) =>
              const HomeScreen(),
        ),
        GoRoute(
          path: '/language',
          builder: (BuildContext context, GoRouterState state) =>
              const LanguageScreen(),
        ),
        GoRoute(
          path: '/exercise/:id',
          builder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id']!;
            return ExerciseDetailScreen(exerciseId: id);
          },
        ),
      ],
      errorBuilder: (BuildContext context, GoRouterState state) => Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      ),
    );

    return MaterialApp.router(
      routerConfig: router,
      title: 'FitPath',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child!,
        );
      },
    );
  }

  ThemeData _buildTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textWhite,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(color: AppColors.textWhite),
        bodyLarge: GoogleFonts.poppins(color: AppColors.textWhite70),
        bodyMedium: GoogleFonts.poppins(color: AppColors.textWhite70),
      ),
      cardTheme: ThemeData.dark().cardTheme.copyWith(
            color: AppColors.card,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textWhite54),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
        ),
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );
  }
}

// Clase de ayuda para la navegación
extension NavigationHelper on BuildContext {
  void pushNamed(String routeName, {Object? arguments}) {
    GoRouter.of(this).push(routeName, extra: arguments);
  }

  void pushReplacementNamed(String routeName, {Object? arguments}) {
    GoRouter.of(this).pushReplacement(routeName, extra: arguments);
  }

  void pop() {
    GoRouter.of(this).pop();
  }

  void popUntilFirst() {
    while (GoRouter.of(this).canPop()) {
      GoRouter.of(this).pop();
    }
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    final authState = ref.watch(authProvider);
    final user = ref.watch(userProvider);

    // Show loading indicator while checking auth state
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Redirect to login if not authenticated
    if (!authState.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isMounted) {
          GoRouter.of(context).go('/login');
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to FitPath'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              // Show loading indicator
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              try {
                // Call logout
                await ref.read(authProvider.notifier).logout();

                // Navigate to login screen
                if (_isMounted) {
                  navigator.pushNamedAndRemoveUntil('/login', (route) => false);
                }
              } catch (e) {
                if (_isMounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Failed to logout: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.user?.name != null)
              Text(
                'Welcome back, ${user.user!.name}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            const SizedBox(height: 16),
            const Text('You are now logged in to FitPath!'),
          ],
        ),
      ),
    );
  }
}

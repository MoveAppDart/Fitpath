class EnvConfig {
  // Base URL configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    // Use 10.0.2.2 for Android emulator, localhost for iOS or web
    defaultValue: 'http://127.0.0.1:8080',
  );

  // For web or iOS you can use: 'http://localhost:3000'

  // Indicates if the app is in production mode
  static const bool isProduction = bool.fromEnvironment(
    'IS_PRODUCTION',
    defaultValue: false,
  );

  // Token expiration time in minutes
  static const int tokenExpirationMinutes = int.fromEnvironment(
    'TOKEN_EXPIRATION_MINUTES',
    defaultValue: 60 * 24 * 7, // 1 week by default
  );

  // Enable detailed API request logs
  static const bool logRequests = bool.fromEnvironment(
    'LOG_REQUESTS',
    defaultValue: true,
  );

  // Base path for API (empty for no versioning)
  static String get basePath => '';

  // ========== Authentication Endpoints ==========
  static String get loginEndpoint => '/login';
  static String get registerEndpoint => '/register';
  static String get logoutEndpoint => '/logout';
  static String get refreshTokenEndpoint => '/refresh';
  static String get verifyEmailEndpoint => '/verify-email';
  static String get requestPasswordResetEndpoint => '/forgot-password';
  static String get resetPasswordEndpoint => '/reset-password';

  // ========== User & Profile Endpoints ==========
  static String get profileEndpoint => '/profile';
  static String get userStatsEndpoint => '/users/me/stats';
  static String get userPreferencesEndpoint => '/users/me/preferences';

  // Alias for backward compatibility
  static String get profileStatsEndpoint => userStatsEndpoint;
  static String get profilePreferencesEndpoint => userPreferencesEndpoint;

  // ========== Workout & Exercise Endpoints ==========
  static String get workoutsEndpoint => '/workouts';
  static String get workoutTemplatesEndpoint => '/workouts/templates';
  static String get workoutLogsEndpoint => '/workouts/logs';

  static String get exercisesEndpoint => '/exercises';
  static String get exerciseCategoriesEndpoint => '/exercises/categories';
  static String get exerciseEquipmentEndpoint => '/exercises/equipment';

  static String get routinesEndpoint => '/routines';
  static String get routineTemplatesEndpoint => '/routines/templates';

  // ========== Calendar & Scheduling ==========
  static String get calendarEndpoint => '/calendar';
  static String get calendarEventsEndpoint => '/calendar/events';
  static String get scheduleEndpoint => '/schedule';

  // ========== Stats & Analytics ==========
  static String get statsEndpoint => '/stats';
  static String get statsWeightEndpoint => '$statsEndpoint/weight';
  static String get statsWorkoutsEndpoint => '$statsEndpoint/workouts';
  static String get statsExercisesEndpoint => '$statsEndpoint/exercises';
  static String get statsMeasurementsEndpoint => '$statsEndpoint/measurements';
  static String get weightEvolutionEndpoint =>
      '$statsEndpoint/weight-evolution';
  static String get workoutFrequencyEndpoint =>
      '$statsEndpoint/workout-frequency';
  static String personalBestEndpoint(String exerciseId) =>
      '$exercisesEndpoint/$exerciseId/personal-best';

  // Weight tracking
  static String get weightLogsEndpoint => '/weight-logs';

  // ========== WGER Integration ==========
  static String get wgerBaseUrl => 'https://wger.de/api/v2';
  static String get wgerExerciseEndpoint => '$wgerBaseUrl/exercise';
  static String get wgerExerciseInfoEndpoint => '$wgerBaseUrl/exerciseinfo';
  static String get wgerExerciseImageEndpoint => '$wgerBaseUrl/exerciseimage';
  static String get wgerExerciseCategoryEndpoint =>
      '$wgerBaseUrl/exercisecategory';
  static String get wgerEquipmentEndpoint => '$wgerBaseUrl/equipment';
  static String get wgerMuscleEndpoint => '$wgerBaseUrl/muscle';

  // Helper method to get WGER exercise endpoint by ID
  static String wgerExerciseByIdEndpoint(int id) => '$wgerExerciseEndpoint/$id';

  // Helper method to get exercise by ID
  static String exerciseByIdEndpoint(String id) => '$exercisesEndpoint/$id';

  // ========== Cache Configuration ==========
  static const int cacheDurationMinutes = int.fromEnvironment(
    'CACHE_DURATION_MINUTES',
    defaultValue: 30,
  );

  static const int imageCacheDurationDays = int.fromEnvironment(
    'IMAGE_CACHE_DURATION_DAYS',
    defaultValue: 7,
  );

  // ========== Pagination Defaults ==========
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ========== Feature Flags ==========
  static bool get enableAnalytics => bool.fromEnvironment(
        'ENABLE_ANALYTICS',
        defaultValue:
            !isProduction, // Disabled in production by default for privacy
      );

  static bool get enableCrashReporting => bool.fromEnvironment(
        'ENABLE_CRASH_REPORTING',
        defaultValue: true,
      );

  // ========== Third-party API Keys ==========
  static String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');
  static String get googleMapsApiKey =>
      const String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static String get onesignalAppId =>
      const String.fromEnvironment('ONESIGNAL_APP_ID');

  // ========== App Settings ==========
  static const String appName = 'FitPath';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ========== Validation Patterns ==========
  static final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  // ========== Other Constants ==========
  static const List<String> supportedLocales = ['en', 'es'];
  static const String defaultLocale = 'en';

  // ========== Debug Settings ==========
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(() {
      inDebugMode = true;
      return true;
    }());
    return inDebugMode;
  }

  // ========== Retry Configuration ==========
  static const int maxRetryAttempts = int.fromEnvironment(
    'MAX_RETRY_ATTEMPTS',
    defaultValue: 3,
  );

  // ========== Timeout Configuration ==========
  static const int connectionTimeoutSeconds = int.fromEnvironment(
    'CONNECTION_TIMEOUT_SECONDS',
    defaultValue: 10,
  );

  static const int receiveTimeoutSeconds = int.fromEnvironment(
    'RECEIVE_TIMEOUT_SECONDS',
    defaultValue: 10,
  );

  // ========== WGER Search ==========
  static String get wgerSearchEndpoint => '$exercisesEndpoint/search';
}

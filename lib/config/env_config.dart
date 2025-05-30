class EnvConfig {
  // URL base de la API
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  
  // Indica si la aplicación está en modo producción
  static const bool isProduction = bool.fromEnvironment(
    'IS_PRODUCTION',
    defaultValue: false,
  );
  
  // Tiempo de expiración del token en minutos
  static const int tokenExpirationMinutes = int.fromEnvironment(
    'TOKEN_EXPIRATION_MINUTES',
    defaultValue: 60,
  );
  
  // Versión de la API
  static const String apiVersion = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );
  
  // Endpoints de Autenticación
  static String get loginEndpoint => '/login';
  static String get registerEndpoint => '/register';
  static String get refreshTokenEndpoint => '/auth/refresh';
  
  // Endpoints de Usuario
  static String get profileEndpoint => '/profile';
  static String get userStatsEndpoint => '/profile/stats';
  static String get userPreferencesEndpoint => '/profile/preferences';
  
  // Endpoints de Entrenamientos
  static String get workoutsEndpoint => '/workouts';
  static String get routinesEndpoint => '/routines';
  static String get exercisesEndpoint => '/exercises';
  static String get calendarEndpoint => '/calendar';
  
  // Endpoints de Seguimiento
  static String get weightLogsEndpoint => '/weight-logs';
  
  // Endpoints de Estadísticas
  static String get statsEndpoint => '/stats';
  static String get weightEvolutionEndpoint => '$statsEndpoint/weight-evolution';
  static String personalBestEndpoint(String exerciseId) => '$statsEndpoint/exercises/$exerciseId/personal-best';
  static String get workoutFrequencyEndpoint => '$statsEndpoint/workout-frequency';
  
  // Configuración de caché
  static const int cacheDurationMinutes = int.fromEnvironment(
    'CACHE_DURATION_MINUTES',
    defaultValue: 30,
  );
  
  // Configuración de reintentos
  static const int maxRetryAttempts = int.fromEnvironment(
    'MAX_RETRY_ATTEMPTS',
    defaultValue: 3,
  );
  
  // Configuración de timeout
  static const int connectionTimeoutSeconds = int.fromEnvironment(
    'CONNECTION_TIMEOUT_SECONDS',
    defaultValue: 10,
  );
  
  static const int receiveTimeoutSeconds = int.fromEnvironment(
    'RECEIVE_TIMEOUT_SECONDS',
    defaultValue: 10,
  );
}

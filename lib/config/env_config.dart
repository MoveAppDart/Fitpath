class EnvConfig {
  static const String apiBaseUrl = 'http://10.0.2.2:3000';
}
    'API_BASE_URL',
    // Usar 10.0.2.2 para emulador Android, localhost para iOS o web
    defaultValue: 'http://10.0.2.2:3000',
  );
  // Para Flutter web o iOS puedes usar: 'http://localhost:3000'

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

  // Habilitar logs detallados de peticiones API
  static const bool logRequests = bool.fromEnvironment(
    'LOG_REQUESTS',
    defaultValue: true,
  );

  // Ya no usamos versionado ni prefijo /api/
  static String get basePath => '';

  // Endpoints de Autenticación
  static String get loginEndpoint => '/login';
  static String get registerEndpoint => '/register';
  static String get logoutEndpoint => '/logout';
  static String get refreshTokenEndpoint =>
      '/auth/refresh'; // Mantenemos auth/ para el refresh si es necesario

  // Endpoints de Perfil
  static String get profileEndpoint => '/profile';
  static String get userStatsEndpoint => '/profile/stats';
  static String get userPreferencesEndpoint => '/profile/preferences';

  // Alias para compatibilidad con código existente
  static String get profileStatsEndpoint => userStatsEndpoint;
  static String get profilePreferencesEndpoint => userPreferencesEndpoint;

  // Endpoints de Entrenamientos (sin versionado)
  static String get workoutsEndpoint => '/workouts';
  static String get routinesEndpoint => '/routines';
  static String get exercisesEndpoint => '/exercises';
  static String get calendarEndpoint => '/calendar';

  // Endpoints de Seguimiento (sin versionado)
  static String get weightLogsEndpoint => '/weight-logs';

  // Endpoints de Estadísticas (sin versionado)
  static String get statsEndpoint => '/stats';
  static String get weightEvolutionEndpoint =>
      '$statsEndpoint/weight-evolution';
  static String personalBestEndpoint(String exerciseId) =>
      '$statsEndpoint/exercises/$exerciseId/personal-best';
  static String get workoutFrequencyEndpoint =>
      '$statsEndpoint/workout-frequency';

  // Endpoints de WGER
  static String getwgerSearchEndpoint => '$exercisesEndpoint/search';
  static String wgerExerciseEndpoint(int id) => '$exercisesEndpoint/$id';
  static String exerciseByIdEndpoint(String id) => '$exercisesEndpoint/$id';

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

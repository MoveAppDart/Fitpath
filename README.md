# FitPath

FitPath es una aplicación móvil de fitness desarrollada con Flutter que permite a los usuarios gestionar sus rutinas de entrenamiento, hacer seguimiento de su progreso y mantener un estilo de vida saludable.

![FitPath App](assets/Gymbro.png)

## 📱 Características

- **Gestión de Rutinas**: Crea y personaliza rutinas de entrenamiento
- **Seguimiento de Progreso**: Visualiza tu historial de entrenamientos y estadísticas
- **Calendario Integrado**: Planifica tus entrenamientos semanales
- **Interfaz Intuitiva**: Diseño moderno y fácil de usar
- **Soporte Multilingüe**: Disponible en inglés, español y francés

## 🚀 Tecnologías

- **Framework**: Flutter 3.5+
- **Lenguaje**: Dart
- **Diseño**: Material Design
- **Fuentes**: Google Fonts

## 🛠️ Instalación

1. **Requisitos previos**:

   - Flutter SDK 3.5.3 o superior
   - Dart SDK
   - Android Studio / Xcode

2. **Clonar el repositorio**:

   ```bash
   git clone https://github.com/tu-usuario/fitpath.git
   cd fitpath
   ```

3. **Instalar dependencias**:

   ```bash
   flutter pub get
   ```

4. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

## 📂 Estructura del Proyecto

```
lib/
├── main.dart                # Punto de entrada de la aplicación
├── screens/                 # Pantallas de la aplicación
│   ├── login_screen.dart    # Pantalla de inicio de sesión
│   ├── signup_screen.dart   # Pantalla de registro
│   ├── home_screen.dart     # Pantalla principal
│   ├── calendar_screen.dart # Calendario de entrenamientos
│   └── ...
├── services/                # Servicios y lógica de negocio
│   ├── data_service.dart    # Servicio de datos (mock)
│   └── localization_service.dart # Servicio de localización
└── ...
```

## 🔄 Integración con API

La aplicación está completamente integrada con una API RESTful desarrollada en Go. A continuación, se detalla la arquitectura de integración y los componentes principales.

### Arquitectura de la Integración

La integración sigue un patrón de arquitectura en capas:

1. **Capa de Servicios API**: Encapsula todas las llamadas a la API RESTful
2. **Capa de Proveedores (Providers)**: Gestiona el estado y la lógica de negocio
3. **Capa de UI**: Presenta los datos y captura las interacciones del usuario

### Configuración de la API

La configuración de la API se centraliza en `lib/config/env_config.dart`:

```dart
class EnvConfig {
  // URL base de la API
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
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
  
  // Configuración de caché y timeouts
  static const int cacheDurationMinutes = 30;
  static const int maxRetryAttempts = 3;
  static const int connectionTimeoutSeconds = 10;
  static const int receiveTimeoutSeconds = 10;
}
```

### URLs para Diferentes Entornos

- **Desarrollo local** (iOS o navegador web):
  ```
  http://localhost:8080
  ```

- **Emulador Android**:
  ```
  http://10.0.2.2:8080
  ```
  (10.0.2.2 es la dirección IP que Android usa para referirse al localhost de la máquina host)

- **Dispositivo físico**:
  ```
  http://192.168.1.100:8080
  ```
  (Usar la IP de tu computadora en la red local)

### Cliente API

El cliente API (`lib/services/api/api_client.dart`) implementa:

- **Gestión de tokens**: Almacenamiento seguro y refresco automático
- **Interceptores**: Para añadir headers de autenticación y manejar errores
- **Caché**: Almacenamiento local de respuestas para funcionamiento offline
- **Reintentos**: Política de reintentos para peticiones fallidas

```dart
class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  
  ApiClient(this._dio, this._secureStorage) {
    _dio.options.baseUrl = EnvConfig.apiBaseUrl;
    _dio.options.connectTimeout = Duration(seconds: EnvConfig.connectionTimeoutSeconds);
    _dio.options.receiveTimeout = Duration(seconds: EnvConfig.receiveTimeoutSeconds);
    
    // Configurar interceptores para tokens, caché, etc.
    _setupInterceptors();
  }
  
  // Métodos para realizar peticiones HTTP
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) { ... }
  Future<dynamic> post(String path, {dynamic data}) { ... }
  Future<dynamic> put(String path, {dynamic data}) { ... }
  Future<dynamic> delete(String path) { ... }
  
  // Métodos para gestión de tokens
  Future<void> _refreshToken() { ... }
  Future<String?> getToken() { ... }
}
```

### Servicios Específicos

La aplicación implementa servicios específicos para cada dominio:

1. **AuthService** (`lib/services/api/auth_service.dart`): Gestiona autenticación y tokens
2. **UserService** (`lib/services/api/user_service.dart`): Maneja perfil y preferencias de usuario
3. **WorkoutService** (`lib/services/api/workout_service.dart`): Gestiona entrenamientos y rutinas
4. **WeightLogService** (`lib/services/api/weight_log_service.dart`): Maneja registros de peso
5. **StatsService** (`lib/services/api/stats_service.dart`): Obtiene estadísticas y progreso

Cada servicio implementa un manejo de errores consistente, retornando respuestas estructuradas:

```dart
// Ejemplo de respuesta exitosa
{'success': true, 'data': responseData}

// Ejemplo de respuesta con error
{'success': false, 'message': 'Error específico', 'statusCode': 400}
```

### Modelos de Datos

Se han implementado modelos para estructurar los datos:

1. **User** (`lib/models/user.dart`): Modelo de usuario
2. **Workout** (`lib/models/workout.dart`): Modelo de entrenamiento
3. **Exercise** (`lib/models/exercise.dart`): Modelo de ejercicio

Cada modelo implementa:
- Constructor desde JSON (`fromJson`)
- Serialización a JSON (`toJson`)
- Método `copyWith` para inmutabilidad

### Proveedores (Providers)

Los proveedores gestionan el estado y la comunicación con los servicios:

1. **AuthProvider** (`lib/providers/auth_provider.dart`): Estado de autenticación
2. **UserProvider** (`lib/providers/user_provider.dart`): Datos del usuario
3. **WorkoutProvider** (`lib/providers/workout_provider.dart`): Entrenamientos y rutinas

Ejemplo de flujo de datos:

```
UI -> Provider -> Service -> API -> Service -> Provider -> UI
```

### Manejo de Errores

La aplicación implementa un manejo de errores en capas:

1. **Nivel API**: Captura errores HTTP y de red
2. **Nivel Servicio**: Procesa errores y los convierte en mensajes amigables
3. **Nivel Provider**: Almacena y propaga errores al UI
4. **Nivel UI**: Muestra mensajes de error contextuales al usuario

### Soporte Offline

La aplicación implementa estrategias para funcionamiento offline:

1. **Caché de Respuestas**: Almacenamiento local de respuestas HTTP
2. **Persistencia de Estado**: Almacenamiento del estado en SharedPreferences
3. **Cola de Operaciones**: Las operaciones realizadas offline se encolan para sincronización

### Seguridad

1. **Almacenamiento Seguro**: Tokens almacenados con flutter_secure_storage
2. **HTTPS**: Todas las comunicaciones utilizan HTTPS
3. **Refresco de Tokens**: Implementación de refresco automático de tokens expirados
4. **Sanitización de Datos**: Validación de datos de entrada y salida

## 🧪 Testing

Para ejecutar las pruebas:

```bash
flutter test
```

## 📱 Plataformas Soportadas

- Android
- iOS
- Web (experimental)

## 🤝 Contribuciones

Por favor, sigue estos pasos:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/amazing-feature`)
3. Haz commit de tus cambios (`git commit -m 'Add some amazing feature'`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

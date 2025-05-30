import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/env_config.dart';

class ApiClient {
  late Dio _dio;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool _isRefreshing = false;
  final Completer<void> _refreshCompleter = Completer<void>();
  
  // Constructor
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: Duration(seconds: EnvConfig.connectionTimeoutSeconds),
      receiveTimeout: Duration(seconds: EnvConfig.receiveTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Interceptor para manejo de tokens y errores
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Añadir token de autenticación si existe
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        // Verificar si hay datos en caché para esta petición (solo para GET)
        if (options.method == 'GET') {
          final cachedData = await _getCachedData(options.path, options.queryParameters);
          if (cachedData != null) {
            // Usar datos en caché si están disponibles
            return handler.resolve(
              Response(
                requestOptions: options,
                data: cachedData,
                statusCode: 200,
                headers: Headers.fromMap({'source': const ['cache']}),
              ),
            );
          }
        }
        
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        // Guardar respuesta en caché si es una petición GET
        if (response.requestOptions.method == 'GET') {
          await _cacheResponse(
            response.requestOptions.path,
            response.requestOptions.queryParameters,
            response.data,
          );
        }
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        // Manejar errores 401 (token expirado)
        if (error.response?.statusCode == 401) {
          if (!_isRefreshing) {
            _isRefreshing = true;
            try {
              // Intentar refrescar el token
              final refreshed = await _refreshToken();
              _isRefreshing = false;
              
              if (refreshed) {
                // Si se refrescó el token, reintentar la petición original
                _refreshCompleter.complete();
                // Obtener el nuevo token
                final newToken = await _storage.read(key: 'access_token');
                // Actualizar el token en la petición original
                error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                // Crear una nueva petición con las mismas opciones
                final clonedRequest = await _dio.request(
                  error.requestOptions.path,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  ),
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                // Resolver con la nueva respuesta
                return handler.resolve(clonedRequest);
              } else {
                // Si no se pudo refrescar el token, limpiar la sesión
                await _clearSession();
                return handler.next(error);
              }
            } catch (e) {
              _isRefreshing = false;
              _refreshCompleter.completeError(e);
              // Si ocurre un error al refrescar el token, limpiar la sesión
              await _clearSession();
              return handler.next(error);
            }
          } else {
            // Si ya se está refrescando el token, esperar a que termine
            try {
              await _refreshCompleter.future;
              // Obtener el nuevo token
              final newToken = await _storage.read(key: 'access_token');
              // Actualizar el token en la petición original
              error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              // Crear una nueva petición con las mismas opciones
              final clonedRequest = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              // Resolver con la nueva respuesta
              return handler.resolve(clonedRequest);
            } catch (e) {
              return handler.next(error);
            }
          }
        }
        
        // Intentar obtener datos de caché si es una petición GET y hay un error de conexión
        if (error.requestOptions.method == 'GET' && 
            (error.type == DioExceptionType.connectionError ||
             error.type == DioExceptionType.connectionTimeout)) {
          final cachedData = await _getCachedData(
            error.requestOptions.path,
            error.requestOptions.queryParameters,
          );
          
          if (cachedData != null) {
            return handler.resolve(
              Response(
                requestOptions: error.requestOptions,
                data: cachedData,
                statusCode: 200,
                headers: Headers.fromMap({'source': const ['cache']}),
              ),
            );
          }
        }
        
        return handler.next(error);
      },
    ));
    
    // Añadir interceptor de reintentos para peticiones fallidas
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: print,
      retries: EnvConfig.maxRetryAttempts,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
      retryableExtraStatuses: {401}, // Reintentar en caso de token expirado
    ));
    
    // Añadir interceptor de logging para desarrollo
    if (!EnvConfig.isProduction) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }
  
  // Métodos para peticiones HTTP
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      return response.data;
    } catch (e) {
      final error = _handleError(e);
      throw error;
    }
  }
  
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } catch (e) {
      final error = _handleError(e);
      throw error;
    }
  }
  
  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } catch (e) {
      final error = _handleError(e);
      throw error;
    }
  }
  
  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } catch (e) {
      final error = _handleError(e);
      throw error;
    }
  }
  
  // Método para refrescar el token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        return false;
      }
      
      // Crear un nuevo Dio para evitar ciclos infinitos con el interceptor
      final refreshDio = Dio(BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        headers: {'Content-Type': 'application/json'},
      ));
      
      final response = await refreshDio.post(
        EnvConfig.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );
      
      if (response.statusCode == 200 && response.data['token'] != null) {
        // Guardar el nuevo token
        await _storage.write(key: 'access_token', value: response.data['token']);
        if (response.data['refresh_token'] != null) {
          await _storage.write(key: 'refresh_token', value: response.data['refresh_token']);
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error al refrescar el token: $e');
      return false;
    }
  }
  
  // Método para limpiar la sesión
  Future<void> _clearSession() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    // Notificar a la aplicación que la sesión ha sido cerrada
    // Esto se implementará con un provider
  }
  
  // Método para guardar respuestas en caché
  Future<void> _cacheResponse(String path, Map<String, dynamic>? queryParams, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getCacheKey(path, queryParams);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final cacheData = {
        'data': data,
        'timestamp': timestamp,
      };
      await prefs.setString(key, cacheData.toString());
    } catch (e) {
      print('Error al guardar en caché: $e');
    }
  }
  
  // Método para obtener datos de caché
  Future<dynamic> _getCachedData(String path, Map<String, dynamic>? queryParams) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getCacheKey(path, queryParams);
      final cachedString = prefs.getString(key);
      
      if (cachedString != null) {
        final cachedData = cachedString as Map<String, dynamic>;
        final timestamp = cachedData['timestamp'] as int;
        final now = DateTime.now().millisecondsSinceEpoch;
        final cacheAge = now - timestamp;
        
        // Verificar si la caché es válida
        if (cacheAge < EnvConfig.cacheDurationMinutes * 60 * 1000) {
          return cachedData['data'];
        }
      }
      return null;
    } catch (e) {
      print('Error al obtener datos de caché: $e');
      return null;
    }
  }
  
  // Método para generar la clave de caché
  String _getCacheKey(String path, Map<String, dynamic>? queryParams) {
    if (queryParams != null && queryParams.isNotEmpty) {
      return 'cache_${path}_${queryParams.toString()}';
    }
    return 'cache_$path';
  }
  
  // Método para manejar errores
  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        // Error con respuesta del servidor
        final statusCode = error.response!.statusCode;
        final data = error.response!.data;
        String message = 'Error del servidor';
        
        // Intentar extraer el mensaje de error de la respuesta
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          message = data['message'];
        } else if (data is Map<String, dynamic> && data.containsKey('error')) {
          message = data['error'];
        }
        
        switch (statusCode) {
          case 400:
            return ApiException(message: message, code: 'BAD_REQUEST', statusCode: statusCode);
          case 401:
            return ApiException(message: 'No autorizado', code: 'UNAUTHORIZED', statusCode: statusCode);
          case 403:
            return ApiException(message: 'Acceso prohibido', code: 'FORBIDDEN', statusCode: statusCode);
          case 404:
            return ApiException(message: 'Recurso no encontrado', code: 'NOT_FOUND', statusCode: statusCode);
          case 409:
            return ApiException(message: message, code: 'CONFLICT', statusCode: statusCode);
          case 422:
            return ApiException(message: 'Datos inválidos', code: 'VALIDATION_ERROR', statusCode: statusCode);
          case 500:
            return ApiException(message: 'Error interno del servidor', code: 'SERVER_ERROR', statusCode: statusCode);
          default:
            return ApiException(message: message, code: 'UNKNOWN', statusCode: statusCode);
        }
      } else {
        // Error sin respuesta del servidor (problemas de conexión)
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
            return ApiException(message: 'Tiempo de conexión agotado', code: 'CONNECTION_TIMEOUT');
          case DioExceptionType.sendTimeout:
            return ApiException(message: 'Tiempo de envío agotado', code: 'SEND_TIMEOUT');
          case DioExceptionType.receiveTimeout:
            return ApiException(message: 'Tiempo de recepción agotado', code: 'RECEIVE_TIMEOUT');
          case DioExceptionType.badResponse:
            return ApiException(message: 'Respuesta incorrecta', code: 'BAD_RESPONSE');
          case DioExceptionType.cancel:
            return ApiException(message: 'Petición cancelada', code: 'REQUEST_CANCELLED');
          case DioExceptionType.connectionError:
            return ApiException(message: 'Error de conexión. Verifica tu conexión a internet.', code: 'CONNECTION_ERROR');
          default:
            return ApiException(message: 'Error desconocido: ${error.message}', code: 'UNKNOWN');
        }
      }
    }
    // Error genérico
    return ApiException(message: 'Error inesperado: $error', code: 'UNEXPECTED_ERROR');
  }
}

// Clase para manejar excepciones de la API
class ApiException implements Exception {
  final String message;
  final String code;
  final int? statusCode;
  
  ApiException({required this.message, required this.code, this.statusCode});
  
  @override
  String toString() => 'ApiException: $message (Code: $code, Status: $statusCode)';
}

// Interceptor de reintentos para peticiones fallidas
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Function(String message) logPrint;
  final int retries;
  final List<Duration> retryDelays;
  final Set<int>? retryableExtraStatuses;
  
  RetryInterceptor({
    required this.dio,
    required this.logPrint,
    this.retries = 3,
    this.retryDelays = const [Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 3)],
    this.retryableExtraStatuses,
  });
  
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    var retryableStatuses = {401, 408, 429, 500, 502, 503, 504};
    if (retryableExtraStatuses != null) {
      retryableStatuses = {...retryableStatuses, ...retryableExtraStatuses!};
    }
    
    final shouldRetry = _shouldRetry(err, retryableStatuses);
    var extra = err.requestOptions.extra;
    var retryCount = extra['retryCount'] ?? 0;
    
    if (shouldRetry && retryCount < retries) {
      await Future.delayed(retryDelays[retryCount]);
      logPrint('Reintentando petición (${retryCount + 1}/$retries): ${err.requestOptions.path}');
      
      // Incrementar el contador de reintentos
      extra['retryCount'] = retryCount + 1;
      
      try {
        final response = await dio.fetch(err.requestOptions..extra = extra);
        return handler.resolve(response);
      } catch (e) {
        return super.onError(e is DioException ? e : DioException(requestOptions: err.requestOptions, error: e), handler);
      }
    }
    
    return super.onError(err, handler);
  }
  
  bool _shouldRetry(DioException err, Set<int> retryableStatuses) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response != null && retryableStatuses.contains(err.response!.statusCode));
  }
}

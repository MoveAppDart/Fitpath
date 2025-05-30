import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';
import '../../config/env_config.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  
  AuthService(this._apiClient);
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.post(EnvConfig.loginEndpoint, data: {
        'email': email,
        'password': password,
      });
      
      await _storage.write(key: 'access_token', value: response['token']);
      return {'success': true};
    } catch (e) {
      // Manejar diferentes tipos de errores
      if (e is DioException) {
        if (e.response != null) {
          // Error de respuesta del servidor
          if (e.response!.statusCode == 401) {
            return {
              'success': false,
              'message': 'Email o contraseña incorrectos'
            };
          } else if (e.response!.statusCode == 404) {
            return {
              'success': false,
              'message': 'Usuario no encontrado'
            };
          } else {
            // Otros errores del servidor
            return {
              'success': false,
              'message': 'Error del servidor: ${e.response!.statusCode}'
            };
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.sendTimeout) {
          // Errores de timeout
          return {
            'success': false,
            'message': 'Tiempo de espera agotado. Verifica tu conexión a internet.'
          };
        } else if (e.type == DioExceptionType.connectionError) {
          // Error de conexión
          return {
            'success': false,
            'message': 'No se pudo conectar al servidor. Verifica tu conexión a internet.'
          };
        }
      }
      
      // Error genérico
      return {
        'success': false,
        'message': 'Error al iniciar sesión: ${e.toString()}'
      };
    }
  }
  
  Future<bool> register(String email, String password, String name) async {
    try {
      await _apiClient.post(EnvConfig.registerEndpoint, data: {
        'email': email,
        'password': password,
        'name': name
      });
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }
  
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }
}

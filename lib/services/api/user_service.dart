import 'package:dio/dio.dart';
import 'api_client.dart';
import '../../config/env_config.dart';

class UserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  /// Obtiene el perfil del usuario actual
  /// Retorna un mapa con la información del perfil o un mapa con error
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiClient.get(EnvConfig.profileEndpoint);
      // Extraer los datos del objeto Response
      final responseData = response.data;
      return {'success': true, 'data': responseData};
    } on DioException catch (e) {
      return _handleError(e, 'Error al obtener el perfil');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Actualiza el perfil del usuario
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response =
          await _apiClient.put(EnvConfig.profileEndpoint, data: profileData);
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al actualizar el perfil');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Obtiene las estadísticas básicas del usuario
  /// Retorna un mapa con las estadísticas o un mapa con error
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await _apiClient.get(EnvConfig.userStatsEndpoint);
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al obtener estadísticas');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Actualiza las preferencias del usuario
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> updatePreferences(
      Map<String, dynamic> preferences) async {
    try {
      final response = await _apiClient.put(
        EnvConfig.userPreferencesEndpoint,
        data: preferences,
      );
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al actualizar preferencias');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Obtiene las preferencias del usuario
  /// Retorna un mapa con las preferencias o un mapa con error
  Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      final response = await _apiClient.get(EnvConfig.userPreferencesEndpoint);
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al obtener preferencias');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Actualiza las preferencias del usuario
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> updateUserPreferences(
      Map<String, dynamic> preferences) async {
    try {
      final response = await _apiClient.put(EnvConfig.userPreferencesEndpoint,
          data: preferences);
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al actualizar preferencias');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Maneja los errores de las peticiones HTTP
  Map<String, dynamic> _handleError(DioException e, String defaultMessage) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final responseData = e.response!.data;

      if (responseData is Map && responseData.containsKey('message')) {
        return {
          'success': false,
          'message': responseData['message'],
          'statusCode': statusCode
        };
      }

      switch (statusCode) {
        case 400:
          return {
            'success': false,
            'message': 'Solicitud incorrecta',
            'statusCode': statusCode
          };
        case 401:
          return {
            'success': false,
            'message': 'No autorizado',
            'statusCode': statusCode
          };
        case 403:
          return {
            'success': false,
            'message': 'Acceso prohibido',
            'statusCode': statusCode
          };
        case 404:
          return {
            'success': false,
            'message': 'Recurso no encontrado',
            'statusCode': statusCode
          };
        case 500:
          return {
            'success': false,
            'message': 'Error interno del servidor',
            'statusCode': statusCode
          };
        default:
          return {
            'success': false,
            'message': '$defaultMessage ($statusCode)',
            'statusCode': statusCode
          };
      }
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return {'success': false, 'message': 'Tiempo de conexión agotado'};
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return {'success': false, 'message': 'Tiempo de respuesta agotado'};
    } else if (e.type == DioExceptionType.connectionError) {
      return {
        'success': false,
        'message': 'Error de conexión. Verifique su conexión a internet'
      };
    }

    return {'success': false, 'message': defaultMessage};
  }
}

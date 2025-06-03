import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_client.dart';
import 'auth_service.dart';
import '../../config/env_config.dart';

class WorkoutService {
  final ApiClient _apiClient;
  final AuthService _authService;

  WorkoutService(this._apiClient, this._authService);

  /// Verifica si el token es válido antes de hacer una petición
  /// Si no es válido, intenta refrescarlo
  Future<bool> _ensureValidToken() async {
    debugPrint('Verificando validez del token antes de petición');
    if (!await _authService.isLoggedIn()) {
      debugPrint('Usuario no autenticado o token inválido');
      return await _authService.refreshToken();
    }
    return true;
  }

  /// Obtiene la lista de entrenamientos del usuario
  /// Retorna un mapa con la lista de entrenamientos o un mapa con error
  Future<Map<String, dynamic>> getWorkouts() async {
    try {
      if (!await _ensureValidToken()) {
        return {
          'success': false,
          'message': 'No autorizado',
          'statusCode': 401
        };
      }

      final response = await _apiClient.get(EnvConfig.workoutsEndpoint);
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': true, 'data': responseData};
      }
    } on DioException catch (e) {
      final error = _handleError(e, 'Error al obtener entrenamientos');
      if (error['statusCode'] == 401) {
        // Si es error 401, intentar refrescar token y reintentar
        if (await _authService.refreshToken()) {
          return getWorkouts(); // Reintento recursivo
        }
      }
      return error;
    } catch (e) {
      debugPrint('Error inesperado en getWorkouts: $e');
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Obtiene un entrenamiento específico por su ID
  /// Retorna un mapa con el entrenamiento o un mapa con error
  Future<Map<String, dynamic>> getWorkout(String id) async {
    try {
      if (!await _ensureValidToken()) {
        return {
          'success': false,
          'message': 'No autorizado',
          'statusCode': 401
        };
      }

      final response = await _apiClient.get('${EnvConfig.workoutsEndpoint}/$id');
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': true, 'data': responseData};
      }
    } on DioException catch (e) {
      final error = _handleError(e, 'Error al obtener el entrenamiento');
      if (error['statusCode'] == 401) {
        // Si es error 401, intentar refrescar token y reintentar
        if (await _authService.refreshToken()) {
          return getWorkout(id); // Reintento recursivo
        }
      }
      return error;
    } catch (e) {
      debugPrint('Error inesperado en getWorkout: $e');
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Obtiene los ejercicios de un entrenamiento específico
  /// Retorna un mapa con la lista de ejercicios o un mapa con error
  Future<Map<String, dynamic>> getExercisesForWorkout(String workoutId) async {
    try {
      if (!await _ensureValidToken()) {
        return {
          'success': false,
          'message': 'No autorizado',
          'statusCode': 401
        };
      }

      final response = await _apiClient
          .get('${EnvConfig.workoutsEndpoint}/$workoutId/exercises');
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': true, 'data': responseData};
      }
    } on DioException catch (e) {
      final error = _handleError(e, 'Error al obtener ejercicios del entrenamiento');
      if (error['statusCode'] == 401) {
        // Si es error 401, intentar refrescar token y reintentar
        if (await _authService.refreshToken()) {
          return getExercisesForWorkout(workoutId); // Reintento recursivo
        }
      }
      return error;
    } catch (e) {
      debugPrint('Error inesperado en getExercisesForWorkout: $e');
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Crea un nuevo entrenamiento
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> createWorkout(
      Map<String, dynamic> workoutData) async {
    try {
      if (!await _ensureValidToken()) {
        return {
          'success': false,
          'message': 'No autorizado',
          'statusCode': 401
        };
      }

      final response =
          await _apiClient.post(EnvConfig.workoutsEndpoint, data: workoutData);
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': true, 'data': responseData};
      }
    } on DioException catch (e) {
      final error = _handleError(e, 'Error al crear el entrenamiento');
      if (error['statusCode'] == 401) {
        // Si es error 401, intentar refrescar token y reintentar
        if (await _authService.refreshToken()) {
          return createWorkout(workoutData); // Reintento recursivo
        }
      }
      return error;
    } catch (e) {
      debugPrint('Error inesperado en createWorkout: $e');
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Actualiza un entrenamiento existente
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> updateWorkout(
      String id, Map<String, dynamic> workoutData) async {
    try {
      if (!await _ensureValidToken()) {
        return {
          'success': false,
          'message': 'No autorizado',
          'statusCode': 401
        };
      }

      final response = await _apiClient.put('${EnvConfig.workoutsEndpoint}/$id',
          data: workoutData);
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': true, 'data': responseData};
      }
    } on DioException catch (e) {
      final error = _handleError(e, 'Error al actualizar el entrenamiento');
      if (error['statusCode'] == 401) {
        // Si es error 401, intentar refrescar token y reintentar
        if (await _authService.refreshToken()) {
          return updateWorkout(id, workoutData); // Reintento recursivo
        }
      }
      return error;
    } catch (e) {
      debugPrint('Error inesperado en updateWorkout: $e');
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Elimina un entrenamiento
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> deleteWorkout(String id) async {
    try {
      if (!await _ensureValidToken()) {
        return {
          'success': false,
          'message': 'No autorizado',
          'statusCode': 401
        };
      }

      final response =
          await _apiClient.delete('${EnvConfig.workoutsEndpoint}/$id');
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': true, 'data': responseData};
      }
    } on DioException catch (e) {
      final error = _handleError(e, 'Error al eliminar el entrenamiento');
      if (error['statusCode'] == 401) {
        // Si es error 401, intentar refrescar token y reintentar
        if (await _authService.refreshToken()) {
          return deleteWorkout(id); // Reintento recursivo
        }
      }
      return error;
    } catch (e) {
      debugPrint('Error inesperado en deleteWorkout: $e');
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Registra un entrenamiento como completado
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> logCompletedWorkout(
      String workoutId, Map<String, dynamic> completionData) async {
    try {
      if (!await _ensureValidToken()) {
        return {
          'success': false,
          'message': 'No autorizado',
          'statusCode': 401
        };
      }

      final response = await _apiClient.post(
          '${EnvConfig.workoutsEndpoint}/$workoutId/complete',
          data: completionData);
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': true, 'data': responseData};
      }
    } on DioException catch (e) {
      final error = _handleError(e, 'Error al registrar entrenamiento completado');
      if (error['statusCode'] == 401) {
        // Si es error 401, intentar refrescar token y reintentar
        if (await _authService.refreshToken()) {
          return logCompletedWorkout(workoutId, completionData); // Reintento recursivo
        }
      }
      return error;
    } catch (e) {
      debugPrint('Error inesperado en logCompletedWorkout: $e');
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Obtiene el calendario de entrenamientos
  /// Retorna un mapa con el calendario o un mapa con error
  Future<Map<String, dynamic>> getWorkoutCalendar(
      String startDate, String endDate) async {
    try {
      if (!await _ensureValidToken()) {
        return {
          'success': false,
          'message': 'No autorizado',
          'statusCode': 401
        };
      }

      final response = await _apiClient.get(
          '${EnvConfig.calendarEndpoint}?start_date=$startDate&end_date=$endDate');
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': true, 'data': responseData};
      }
    } on DioException catch (e) {
      final error = _handleError(e, 'Error al obtener el calendario');
      if (error['statusCode'] == 401) {
        // Si es error 401, intentar refrescar token y reintentar
        if (await _authService.refreshToken()) {
          return getWorkoutCalendar(startDate, endDate); // Reintento recursivo
        }
      }
      return error;
    } catch (e) {
      debugPrint('Error inesperado en getWorkoutCalendar: $e');
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Obtiene las rutinas de entrenamiento del usuario
  /// Retorna un mapa con la lista de rutinas o un mapa con error
  Future<Map<String, dynamic>> getRoutines() async {
    try {
      if (!await _ensureValidToken()) {
        return {
          'success': false,
          'message': 'No autorizado',
          'statusCode': 401
        };
      }

      final response = await _apiClient.get(EnvConfig.routinesEndpoint);
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': true, 'data': responseData};
      }
    } on DioException catch (e) {
      final error = _handleError(e, 'Error al obtener rutinas');
      if (error['statusCode'] == 401) {
        // Si es error 401, intentar refrescar token y reintentar
        if (await _authService.refreshToken()) {
          return getRoutines(); // Reintento recursivo
        }
      }
      return error;
    } catch (e) {
      debugPrint('Error inesperado en getRoutines: $e');
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  /// Obtiene una rutina específica por su ID
  /// Retorna un mapa con la rutina o un mapa con error
  Future<Map<String, dynamic>> getRoutine(String id) async {
    try {
      if (!await _ensureValidToken()) {
        return {
          'success': false,
          'message': 'No autorizado',
          'statusCode': 401
        };
      }

      final response =
          await _apiClient.get('${EnvConfig.routinesEndpoint}/$id');
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': true, 'data': responseData};
      }
    } on DioException catch (e) {
      final error = _handleError(e, 'Error al obtener la rutina');
      if (error['statusCode'] == 401) {
        // Si es error 401, intentar refrescar token y reintentar
        if (await _authService.refreshToken()) {
          return getRoutine(id); // Reintento recursivo
        }
      }
      return error;
    } catch (e) {
      debugPrint('Error inesperado en getRoutine: $e');
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

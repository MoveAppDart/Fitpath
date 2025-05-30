import 'package:dio/dio.dart';
import 'api_client.dart';
import '../../config/env_config.dart';

class WorkoutService {
  final ApiClient _apiClient;
  
  WorkoutService(this._apiClient);
  
  /// Obtiene la lista de entrenamientos del usuario
  /// Retorna un mapa con la lista de entrenamientos o un mapa con error
  Future<Map<String, dynamic>> getWorkouts() async {
    try {
      final response = await _apiClient.get(EnvConfig.workoutsEndpoint);
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al obtener entrenamientos');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
  
  /// Obtiene un entrenamiento específico por su ID
  /// Retorna un mapa con el entrenamiento o un mapa con error
  Future<Map<String, dynamic>> getWorkout(String id) async {
    try {
      final response = await _apiClient.get('${EnvConfig.workoutsEndpoint}/$id');
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al obtener el entrenamiento');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
  
  /// Obtiene los ejercicios de un entrenamiento específico
  /// Retorna un mapa con la lista de ejercicios o un mapa con error
  Future<Map<String, dynamic>> getExercisesForWorkout(String workoutId) async {
    try {
      final response = await _apiClient.get('${EnvConfig.workoutsEndpoint}/$workoutId/exercises');
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al obtener ejercicios del entrenamiento');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
  
  /// Crea un nuevo entrenamiento
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> createWorkout(Map<String, dynamic> workoutData) async {
    try {
      final response = await _apiClient.post(EnvConfig.workoutsEndpoint, data: workoutData);
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al crear el entrenamiento');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
  
  /// Actualiza un entrenamiento existente
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> updateWorkout(String id, Map<String, dynamic> workoutData) async {
    try {
      final response = await _apiClient.put('${EnvConfig.workoutsEndpoint}/$id', data: workoutData);
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al actualizar el entrenamiento');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
  
  /// Elimina un entrenamiento
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> deleteWorkout(String id) async {
    try {
      final response = await _apiClient.delete('${EnvConfig.workoutsEndpoint}/$id');
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al eliminar el entrenamiento');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
  
  /// Registra un entrenamiento como completado
  /// Retorna un mapa con el resultado de la operación
  Future<Map<String, dynamic>> logCompletedWorkout(String workoutId, Map<String, dynamic> completionData) async {
    try {
      final response = await _apiClient.post('${EnvConfig.workoutsEndpoint}/$workoutId/complete', data: completionData);
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al registrar entrenamiento completado');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
  
  /// Obtiene el calendario de entrenamientos
  /// Retorna un mapa con el calendario o un mapa con error
  Future<Map<String, dynamic>> getWorkoutCalendar(String startDate, String endDate) async {
    try {
      final response = await _apiClient.get(
        '${EnvConfig.calendarEndpoint}?start_date=$startDate&end_date=$endDate'
      );
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al obtener el calendario');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
  
  /// Obtiene las rutinas de entrenamiento del usuario
  /// Retorna un mapa con la lista de rutinas o un mapa con error
  Future<Map<String, dynamic>> getRoutines() async {
    try {
      final response = await _apiClient.get(EnvConfig.routinesEndpoint);
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al obtener rutinas');
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
  
  /// Obtiene una rutina específica por su ID
  /// Retorna un mapa con la rutina o un mapa con error
  Future<Map<String, dynamic>> getRoutine(String id) async {
    try {
      final response = await _apiClient.get('${EnvConfig.routinesEndpoint}/$id');
      return {'success': true, 'data': response};
    } on DioException catch (e) {
      return _handleError(e, 'Error al obtener la rutina');
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
        return {'success': false, 'message': responseData['message'], 'statusCode': statusCode};
      }
      
      switch (statusCode) {
        case 400:
          return {'success': false, 'message': 'Solicitud incorrecta', 'statusCode': statusCode};
        case 401:
          return {'success': false, 'message': 'No autorizado', 'statusCode': statusCode};
        case 403:
          return {'success': false, 'message': 'Acceso prohibido', 'statusCode': statusCode};
        case 404:
          return {'success': false, 'message': 'Recurso no encontrado', 'statusCode': statusCode};
        case 500:
          return {'success': false, 'message': 'Error interno del servidor', 'statusCode': statusCode};
        default:
          return {'success': false, 'message': '$defaultMessage (${statusCode})', 'statusCode': statusCode};
      }
    }
    
    if (e.type == DioExceptionType.connectionTimeout) {
      return {'success': false, 'message': 'Tiempo de conexión agotado'};
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return {'success': false, 'message': 'Tiempo de respuesta agotado'};
    } else if (e.type == DioExceptionType.connectionError) {
      return {'success': false, 'message': 'Error de conexión. Verifique su conexión a internet'};
    }
    
    return {'success': false, 'message': defaultMessage};
  }
}

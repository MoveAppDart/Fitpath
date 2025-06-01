import 'dart:convert';
import 'package:dio/dio.dart';
import '../../models/api_response.dart';

/// Interceptor para procesar automáticamente las respuestas de la API
/// según el formato estandarizado
class ApiResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      // Si la respuesta ya es un ApiResponse, no es necesario procesarla
      if (response.data is ApiResponse) {
        return handler.next(response);
      }
      
      // Convertir la respuesta al formato ApiResponse
      dynamic responseData = response.data;
      Map<String, dynamic> jsonData;
      
      // Manejar diferentes formatos de respuesta
      if (responseData is String) {
        try {
          jsonData = json.decode(responseData) as Map<String, dynamic>;
        } catch (e) {
          // Si no es un JSON válido, crear una respuesta exitosa con el texto como mensaje
          jsonData = {
            'success': true,
            'message': responseData,
            'data': null
          };
        }
      } else if (responseData is Map<String, dynamic>) {
        jsonData = responseData;
      } else {
        // Si no es un formato reconocido, crear una respuesta con los datos tal cual
        jsonData = {
          'success': true,
          'message': 'OK',
          'data': responseData
        };
      }
      
      // Verificar si la respuesta ya tiene el formato estándar
      if (!jsonData.containsKey('success')) {
        // Si no tiene el formato estándar, convertirla
        jsonData = {
          'success': true,
          'message': 'OK',
          'data': jsonData
        };
      }
      
      // Actualizar los datos de la respuesta
      response.data = jsonData;
      
      return handler.next(response);
    } catch (e) {
      print('Error en ApiResponseInterceptor: $e');
      return handler.next(response);
    }
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      // Procesar errores para convertirlos al formato estándar
      Response? response = err.response;
      
      if (response != null && response.data != null) {
        dynamic errorData = response.data;
        Map<String, dynamic> errorJson;
        
        // Convertir la respuesta de error a un formato estándar
        if (errorData is String) {
          try {
            errorJson = json.decode(errorData) as Map<String, dynamic>;
          } catch (e) {
            // Si no es un JSON válido, crear un error con el texto como mensaje
            errorJson = {
              'success': false,
              'message': errorData,
              'errorType': _mapStatusCodeToErrorType(response.statusCode),
              'statusCode': response.statusCode
            };
          }
        } else if (errorData is Map<String, dynamic>) {
          errorJson = errorData;
        } else {
          // Si no es un formato reconocido, crear un error genérico
          errorJson = {
            'success': false,
            'message': 'Error desconocido',
            'errorType': _mapStatusCodeToErrorType(response.statusCode),
            'statusCode': response.statusCode
          };
        }
        
        // Asegurar que tenga el campo success
        if (!errorJson.containsKey('success')) {
          errorJson['success'] = false;
        }
        
        // Asegurar que tenga un mensaje de error
        if (!errorJson.containsKey('message') || errorJson['message'] == null) {
          errorJson['message'] = 'Error en la solicitud';
        }
        
        // Asegurar que tenga un tipo de error
        if (!errorJson.containsKey('errorType') || errorJson['errorType'] == null) {
          errorJson['errorType'] = _mapStatusCodeToErrorType(response.statusCode);
        }
        
        // Actualizar los datos de la respuesta de error
        response.data = errorJson;
      } else {
        // Si no hay respuesta, crear una respuesta de error genérica
        final errorJson = {
          'success': false,
          'message': err.message ?? 'Error de conexión',
          'errorType': err.type.name,
          'statusCode': err.response?.statusCode
        };
        
        // Crear una respuesta si no existe
        if (err.response == null) {
          err = err.copyWith(
            response: Response(
              requestOptions: err.requestOptions,
              data: errorJson,
              statusCode: 0
            )
          );
        } else {
          err.response!.data = errorJson;
        }
      }
    } catch (e) {
      print('Error en ApiResponseInterceptor.onError: $e');
    }
    
    // Continuar con el manejo del error
    return handler.next(err);
  }
  
  /// Mapea códigos de estado HTTP a tipos de error estandarizados
  String _mapStatusCodeToErrorType(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'BAD_REQUEST';
      case 401:
        return 'UNAUTHORIZED';
      case 403:
        return 'FORBIDDEN';
      case 404:
        return 'NOT_FOUND';
      case 409:
        return 'CONFLICT';
      case 422:
        return 'VALIDATION_ERROR';
      case 500:
        return 'SERVER_ERROR';
      case 503:
        return 'SERVICE_UNAVAILABLE';
      default:
        return 'UNKNOWN_ERROR';
    }
  }
}

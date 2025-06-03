import 'dart:convert';

/// Clase para manejar respuestas estandarizadas de la API
/// 
/// Formato estándar:
/// ```json
/// {
///   "success": true,
///   "data": { ... },
///   "message": "Mensaje descriptivo"
/// }
/// ```
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final String? errorType;
  final String? errorCode;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    required this.message,
    this.errorType,
    this.errorCode,
    this.statusCode,
  });

  /// Creates a successful ApiResponse with the given data
  factory ApiResponse.success(T data, {String message = 'Success'}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
    );
  }

  /// Creates an error ApiResponse with the given message and optional error details
  factory ApiResponse.error({
    required String message,
    String? errorType,
    String? errorCode,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errorType: errorType,
      errorCode: errorCode,
      statusCode: statusCode,
    );
  }

  /// Crea una instancia de ApiResponse a partir de un Map JSON
  /// 
  /// [json] El mapa JSON de la respuesta
  /// [fromJson] Función para convertir el campo 'data' al tipo T
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJson
  ) {
    // Extraer datos según el formato estandarizado
    final bool success = json['success'] == true;
    final String message = json['message'] as String? ?? '';
    
    // Extraer información de error si está presente
    final String? errorType = json['errorType'] as String? ?? 
                             json['error_type'] as String?;
    final String? errorCode = json['code'] as String? ?? 
                             json['errorCode'] as String?;
    final int? statusCode = json['statusCode'] as int?;
    
    // Procesar el campo data si existe y hay un conversor
    T? data;
    if (json.containsKey('data') && json['data'] != null && fromJson != null) {
      try {
        data = fromJson(json['data']);
      } catch (e) {
        print('Error al convertir data: $e');
      }
    }
    
    return ApiResponse(
      success: success,
      data: data,
      message: message,
      errorType: errorType,
      errorCode: errorCode,
      statusCode: statusCode,
    );
  }
  
  /// Crea una instancia de ApiResponse a partir de una cadena JSON
  /// 
  /// [jsonString] La cadena JSON de la respuesta
  /// [fromJson] Función para convertir el campo 'data' al tipo T
  static ApiResponse<T> fromJsonString<T>(
    String jsonString,
    T Function(dynamic)? fromJson
  ) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ApiResponse.fromJson(json, fromJson);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error al procesar respuesta: $e',
        errorType: 'PARSE_ERROR',
      );
    }
  }
  
  /// Convierte la respuesta a un Map JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'message': message,
      if (errorType != null) 'errorType': errorType,
      if (errorCode != null) 'code': errorCode,
      if (statusCode != null) 'statusCode': statusCode,
    };
  }
  
  /// Verifica si el error es de un tipo específico
  bool isErrorType(String type) {
    return !success && errorType == type;
  }
  
  @override
  String toString() {
    return 'ApiResponse{success: $success, message: $message, errorType: $errorType, data: $data}';
  }
}

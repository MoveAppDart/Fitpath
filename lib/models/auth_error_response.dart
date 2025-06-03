class AuthErrorResponse {
  final bool success;
  final String error;
  final String message;
  final dynamic details;

  AuthErrorResponse({
    required this.success,
    required this.error,
    required this.message,
    this.details,
  });

  factory AuthErrorResponse.fromJson(Map<String, dynamic> json) =>
      AuthErrorResponse(
        success: json['success'] as bool,
        error: json['error'] as String,
        message: json['message'] as String,
        details: json['details'],
      );
}

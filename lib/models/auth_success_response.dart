import 'user.dart';

class AuthSuccessResponse {
  final bool success;
  final String accessToken;
  final String? refreshToken;
  final User user;
  final String message;

  AuthSuccessResponse({
    required this.success,
    required this.accessToken,
    this.refreshToken,
    required this.user,
    required this.message,
  });

  factory AuthSuccessResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return AuthSuccessResponse(
      success: json['success'] as bool? ?? false,
      accessToken: (data['access_token'] ?? '') as String,
      refreshToken: data['refresh_token'] as String?,
      user: User.fromJson(data['user'] ?? {}),
      message: (json['message'] ?? '') as String,
    );
  }
}

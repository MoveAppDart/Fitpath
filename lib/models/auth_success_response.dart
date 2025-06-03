import 'user.dart';

class AuthSuccessResponse {
  final bool success;
  final String accessToken;
  final User user;
  final String message;

  AuthSuccessResponse({
    required this.success,
    required this.accessToken,
    required this.user,
    required this.message,
  });

  factory AuthSuccessResponse.fromJson(Map<String, dynamic> json) =>
      AuthSuccessResponse(
        success: json['success'] as bool,
        accessToken: json['data']['access_token'] as String,
        user: User.fromJson(json['data']['user']),
        message: json['message'] as String,
      );
}

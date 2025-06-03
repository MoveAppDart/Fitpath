import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthSuccessResponse {
  final bool success;
  final Map<String, dynamic> data;

  AuthSuccessResponse({required this.success, required this.data});

  factory AuthSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthSuccessResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthSuccessResponseToJson(this);
}

@JsonSerializable()
class AuthErrorResponse implements Exception {
  final bool success;
  final String message;
  final int statusCode;

  AuthErrorResponse({
    this.success = false,
    required this.message,
    this.statusCode = 400,
  });

  factory AuthErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthErrorResponseToJson(this);

  @override
  String toString() => message;
}

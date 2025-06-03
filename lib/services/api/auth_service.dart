
import 'dart:async';

/// Interface defining the required methods for the authentication service
import 'package:dio/dio.dart';
import 'package:fitpath/config/env_config.dart';
import 'package:fitpath/models/auth_success_response.dart';
import 'package:fitpath/models/auth_error_response.dart';

class AuthService {
  final Dio _dio;
  String? _accessToken;

  AuthService([Dio? dio]) : _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.apiBaseUrl));

  void addAuthInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<AuthSuccessResponse?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      if (response.data['success'] == true) {
        final authResp = AuthSuccessResponse.fromJson(response.data);
        _accessToken = authResp.accessToken;
        return authResp;
      } else {
        throw AuthErrorResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        throw AuthErrorResponse.fromJson(e.response!.data);
      }
      rethrow;
    }
  }

  Future<AuthSuccessResponse?> register(String email, String password, String name) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {'email': email, 'password': password, 'name': name},
      );
      if (response.data['success'] == true) {
        final authResp = AuthSuccessResponse.fromJson(response.data);
        _accessToken = authResp.accessToken;
        return authResp;
      } else {
        throw AuthErrorResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        throw AuthErrorResponse.fromJson(e.response!.data);
      }
      rethrow;
    }
  }

  String? get accessToken => _accessToken;

  // Stubs temporales para evitar errores de referencia
  Future<void> logout() async {}
  Future<bool> isLoggedIn() async => _accessToken != null;
  Future<Map<String, dynamic>?> getUserProfile() async { return null; }
}

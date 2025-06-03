
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fitpath/config/env_config.dart';
import 'package:fitpath/models/auth_success_response.dart';
import 'package:fitpath/models/auth_error_response.dart';

/// Interface defining the required methods for the authentication service
abstract class AuthService {
  final Dio _dio;
  String? _accessToken;
  
  /// Get the Dio instance used for HTTP requests
  Dio get dio => _dio;
  
  /// Get the current access token
  String? get accessToken => _accessToken;
  
  /// Set the access token
  @protected
  void setAccessToken(String? token) => _accessToken = token;

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

  Future<AuthSuccessResponse> register({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required int age,
    required String gender,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {'email': email, 'password': password, 'name': name, 'lastName': lastName, 'age': age, 'gender': gender},
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

  
  /// Refreshes the authentication token using the refresh token
  /// Returns true if the token was refreshed successfully, false otherwise
  Future<bool> refreshToken();

  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<Map<String, dynamic>?> getUserProfile();
  
  /// Updates the user's profile information
  Future<bool> updateProfile({
    required String name,
    required String lastName,
    required int age,
    required String gender,
  });
}

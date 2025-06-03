import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fitpath/models/auth_success_response.dart';
import 'package:fitpath/models/auth_error_response.dart';
import 'auth_service.dart';

class AuthServiceImpl extends AuthService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthServiceImpl([Dio? dio]) : super(dio) {
    // Initialize interceptors
    this
        .dio
        .interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) {
          print('AUTH HEADER: $accessToken'); // <-- Esto debe mostrar el token
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        }, onError: (DioException error, handler) async {
          // Solo intenta refrescar si ya hay un accessToken válido
          if (error.response?.statusCode == 401 && accessToken != null) {
            try {
              await refreshToken();

              // Evitar bucles infinitos
              if (error.requestOptions.extra['retried'] == true) {
                return handler.next(error); // Ya se intentó
              }

              error.requestOptions.extra['retried'] = true;
              final response = await dio!.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error); // refreshToken falló
            }
          }

          return handler.next(error); // otros errores siguen su curso normal
        }));
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      // Check if we have an access token
      final token = await _secureStorage.read(key: _accessTokenKey);
      if (token == null) return false;

      // Set the current access token
      setAccessToken(token);

      // Verify the token is still valid by making an authenticated request
      final response = await dio.get('/verify');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthSuccessResponse> login(String email, String password) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthSuccessResponse.fromJson(response.data!);
        await _saveTokens(authResponse);
        return authResponse;
      } else {
        throw AuthErrorResponse(
          success: false,
          message: 'Failed to login',
          error: 'login_failed',
          details: 'Failed to login',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e, 'Login failed');
    } catch (e) {
      throw AuthErrorResponse(
        success: false,
        message: 'An unexpected error occurred',
        error: 'unexpected_error',
        details: e.toString(),
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final response = await dio.get('/profile');
      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw AuthErrorResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to fetch user profile');
    }
  }

  @override
  Future<bool> updateProfile({
    required String name,
    required String lastName,
    required int age,
    required String gender,
  }) async {
    try {
      final response = await dio.put(
        '/profile',
        data: {
          'name': name,
          'lastName': lastName,
          'age': age,
          'gender': gender,
        },
      );

      if (response.data['success'] == true) {
        // Update the stored user data if available
        final userJson = await _secureStorage.read(key: _userKey);
        if (userJson != null) {
          final userData = jsonDecode(userJson) as Map<String, dynamic>;
          userData.addAll({
            'name': name,
            'lastName': lastName,
            'age': age,
            'gender': gender,
          });
          await _secureStorage.write(
              key: _userKey, value: jsonEncode(userData));
        }
        return true;
      } else {
        throw AuthErrorResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to update profile');
    } catch (e) {
      throw AuthErrorResponse(
        success: false,
        error: 'profile_update_failed',
        message: 'An unexpected error occurred while updating profile',
        details: e.toString(),
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Clear secure storage
      await _secureStorage.deleteAll();

      // Clear in-memory token
      setAccessToken(null);

      // Make API call to invalidate the token on the server
      await dio.post('/logout');
    } catch (e) {
      // Even if logout fails on the server, we still want to clear local storage
      await _secureStorage.deleteAll();
      setAccessToken(null);
      rethrow;
    }
  }

  @override
  Future<bool> refreshToken() async {
    try {
      // Get the refresh token from secure storage
      String? token;
      try {
        // Read the token and handle potential null/empty cases
        final tokenData = await _secureStorage.read(key: _refreshTokenKey);

        // The analyzer incorrectly assumes tokenData can't be null due to FlutterSecureStorage's type definition
        // However, in practice, it can be null if the key doesn't exist
        // ignore: unnecessary_null_comparison
        if (tokenData == null) {
          debugPrint('No refresh token available (null)');
          return false;
        }

        // Convert to string and trim whitespace
        token = tokenData.toString().trim();
        if (token.isEmpty) {
          debugPrint('Refresh token is empty');
          return false;
        }
      } catch (e) {
        debugPrint('Error reading refresh token: $e');
        return false;
      }

      // At this point, we have a non-null, non-empty token

      final response = await dio.post<Map<String, dynamic>>(
        '/refresh',
        data: {'refreshToken': token},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null) {
          debugPrint('Refresh token response data is null');
          return false;
        }

        try {
          final authResponse = AuthSuccessResponse.fromJson(responseData);
          await _saveTokens(authResponse);
          return true;
        } catch (e) {
          debugPrint('Error parsing refresh token response: $e');
          return false;
        }
      }

      debugPrint(
          'Refresh token request failed with status: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrint('Error in refreshToken: $e');
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    // Add the access token to the headers if available
    final token = accessToken;
    if (token != null) {
      options.headers!['Authorization'] = 'Bearer $token';
    }

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> _saveTokens(AuthSuccessResponse response) async {
    final token = response.accessToken;
    setAccessToken(token);
    await _secureStorage.write(key: _accessTokenKey, value: token);

    final refreshToken = response.refreshToken;
    if (refreshToken != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }

    final user = response.user;
    if (user != null) {
      try {
        final userJson = jsonEncode(user.toJson());
        await _secureStorage.write(key: _userKey, value: userJson);
      } catch (e) {
        debugPrint('Failed to save user data: $e');
      }
    }
  }

  AuthErrorResponse _handleDioError(DioException e, String defaultMessage) {
    if (e.response != null) {
      try {
        final errorData = e.response!.data as Map<String, dynamic>?;
        if (errorData != null) {
          return AuthErrorResponse(
            success: errorData['success'] as bool? ?? false,
            error: errorData['error']?.toString() ?? 'unknown_error',
            message: errorData['message']?.toString() ?? defaultMessage,
            details: errorData['details']?.toString(),
          );
        }
      } catch (_) {
        // If we can't parse the error response, continue with the default error
      }
    }

    return AuthErrorResponse(
      success: false,
      error: 'network_error',
      message: e.message ?? defaultMessage,
      details: e.toString(),
    );
  }
}

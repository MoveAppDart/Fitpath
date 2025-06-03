import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitpath/providers/user_provider.dart';
import 'package:fitpath/services/api/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:dio/dio.dart';
import '../../models/auth_success_response.dart';
import '../../models/auth_error_response.dart';

class AuthServiceImpl {
  final Dio _dio;
  String? _accessToken;

  AuthServiceImpl([Dio? dio]) : _dio = dio ?? Dio();

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

  Future<void> logout() async {
    _accessToken = null;
  }

  Future<bool> isLoggedIn() async => _accessToken != null;

  Future<Map<String, dynamic>?> getUserProfile() async {
    // Stub implementation, returns null
    return null;
  }
}
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _authTokenKey);
    if (token == null || token.isEmpty) return false;

    final userJson = await _storage.read(key: _userProfileKey);
    if (userJson != null) {
      try {
        _userProvider.setUserFromMap(jsonDecode(userJson));
        return true;
      } catch (_) {}
    }

    try {
      final response = await _dio.get('\/profile');
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('\/logout');
    } catch (_) {}
    await _clearAuthData();
    _userProvider.clearUser();
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final token = data['access_token'] as String?;
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'No se recibió el token de autenticación',
          'error': 'no_auth_token',
        };
      }

      await _storage.write(key: _authTokenKey, value: token);

      final profile = await getUserProfile();
      if (profile != null) {
        _userProvider.setUserFromMap(profile);
        return {
          'success': true,
          'message': 'Inicio de sesión exitoso',
          'user': profile,
        };
      }

      return {
        'success': true,
        'message': 'Inicio de sesión exitoso, sin perfil completo',
        'user': {'email': email, 'name': '', 'id': ''},
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Error de autenticación',
        'error': e.response?.data['error'] ?? 'authentication_error',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado en login',
        'error': e.toString(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {'email': email, 'password': password, 'name': name},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final token = data['access_token'] as String?;
      final refreshToken = data['refresh_token'] as String?;
      final user = data['user'] as Map<String, dynamic>?;

      if (token == null || user == null) {
        return {
          'success': false,
          'message': 'Datos inválidos del servidor',
          'error': 'invalid_server_response',
        };
      }

      await _storage.write(key: _authTokenKey, value: token);
      if (refreshToken != null) {
        await _storage.write(key: _refreshTokenKey, value: refreshToken);
      }

      final userMap = {
        'id': user['id'].toString(),
        'email': user['email'] ?? email,
        'name': user['name'] ?? name,
        'lastName': user['lastName'] ?? '',
      };

      _userProvider.setUserFromMap(userMap, isNewRegistration: true);

      return {
        'success': true,
        'message': 'Registro exitoso',
        'data': userMap,
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Error al registrar',
        'error': e.response?.data['error'] ?? 'registration_error',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado en el registro',
        'error': e.toString(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final token = await _storage.read(key: _authTokenKey);
      if (token == null) return null;

      final response = await _dio.get('\/profile');
      final profile = response.data['data'] as Map<String, dynamic>?;
      if (profile == null) return null;

      final user = profile['user'] as Map<String, dynamic>? ?? {};
      final userData = {
        'id': user['id']?.toString() ?? profile['userId']?.toString() ?? '',
        'email': user['email'] ?? '',
        'name': user['name'] ?? 'Usuario',
        'lastName': user['lastName'] ?? '',
      };

      await _storage.write(key: _userProfileKey, value: jsonEncode(profile));
      return userData;
    } catch (_) {
      return null;
    }
  }
}

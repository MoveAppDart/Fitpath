import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitpath/providers/user_provider.dart';
import 'package:fitpath/services/api/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AuthServiceImpl implements AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final UserProvider _userProvider;

  AuthServiceImpl({
    required Dio dio,
    required FlutterSecureStorage storage,
    required UserProvider userProvider,
  })  : _dio = dio,
        _storage = storage,
        _userProvider = userProvider {
    // Add pretty logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add content type for all requests
        options.headers['Content-Type'] = 'application/json';
        
        // Skip adding token for login, register, and refresh endpoints
        if (options.path != '/login' &&
            options.path != '/register' &&
            options.path != '/auth/refresh') {
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // Handle 401 Unauthorized
          final request = error.requestOptions;
          
          // Don't retry if we've already tried to refresh
          if (request.headers['retry'] == 'true') {
            await _clearAuthData();
            _userProvider.clearUser();
            return handler.next(error);
          }
          
          // Try to refresh token
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry the original request with new token
            request.headers['retry'] = 'true';
            final token = await _storage.read(key: 'auth_token');
            request.headers['Authorization'] = 'Bearer $token';
            
            try {
              final response = await _dio.fetch(request);
              return handler.resolve(response);
            } on DioException catch (e) {
              return handler.next(e);
            }
          } else {
            await _clearAuthData();
            _userProvider.clearUser();
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      debugPrint('Attempting login for: $email');
      
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      debugPrint('Login response: $responseData');
      
      // Check if login was successful
      if (responseData['success'] != true) {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Authentication failed',
          'error': responseData['error'] ?? 'Unknown error',
        };
      }

      // Extract data from response
      final data = responseData['data'] as Map<String, dynamic>;
      final token = data['access_token'] as String?;
      final userData = data['user'] as Map<String, dynamic>?;
      
      // Validate response data
      if (token == null || userData == null) {
        return {
          'success': false,
          'message': 'Invalid response format from server',
          'error': 'Missing token or user data',
        };
      }
      
      // Store the token securely
      await _storage.write(key: 'auth_token', value: token);
      
      // Update user provider with user data
      _userProvider.setUserFromMap({
        'id': userData['id']?.toString() ?? '',
        'email': userData['email'] ?? '',
        'name': userData['name'] ?? '',
        'lastName': userData['lastName'] ?? '',
      });
      
      // Store user data in secure storage
      await _storage.write(
        key: 'user_profile',
        value: jsonEncode(userData),
      );

      return {
        'success': true,
        'message': responseData['message'] ?? 'Login successful',
        'data': data,
      };
    } on DioException catch (e) {
      String message = 'Login failed';
      dynamic errorData;
      
      if (e.response?.data != null && e.response?.data is Map) {
        message = e.response?.data['message'] ?? message;
        errorData = e.response?.data;
      }
      
      return {
        'success': false,
        'message': message,
        'error': errorData ?? e.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
        'error': e.toString(),
      };
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        debugPrint('No refresh token available');
        return false;
      }

      debugPrint('Attempting to refresh token');
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final responseData = response.data as Map<String, dynamic>;
      debugPrint('Token refresh response: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        final data = responseData['data'] as Map<String, dynamic>;
        final token = data['access_token'] as String?;
        
        if (token != null) {
          await _storage.write(key: 'auth_token', value: token);
          debugPrint('Token refreshed successfully');
          return true;
        }
      }
      
      // If we get here, the refresh failed
      debugPrint('Token refresh failed: ${responseData['message']}');
      await _clearAuthData();
      _userProvider.clearUser();
      return false;
    } on DioException catch (e) {
      debugPrint('Error refreshing token: ${e.message}');
      if (e.response?.statusCode == 401) {
        await _clearAuthData();
        _userProvider.clearUser();
      }
      return false;
    } catch (e) {
      debugPrint('Unexpected error refreshing token: $e');
      return false;
    }
  }

  Future<void> _clearAuthData() async {
    await Future.wait([
      _storage.delete(key: 'auth_token'),
      _storage.delete(key: 'refresh_token'),
      _storage.delete(key: 'user_profile'),
    ]);
  }

  @override
  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    try {
      debugPrint('Attempting to register user: $email');
      
      final response = await _dio.post(
        '/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      debugPrint('Registration response: $responseData');
      
      if (responseData['success'] != true) {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
          'error': responseData['error'] ?? 'Unknown error',
        };
      }

      // Extract data from response
      final data = responseData['data'] as Map<String, dynamic>?;
      if (data != null) {
        final token = data['access_token'] as String?;
        final userData = data['user'] as Map<String, dynamic>?;
        
        if (token != null && userData != null) {
          await _storage.write(key: 'auth_token', value: token);
          
          _userProvider.setUserFromMap({
            'id': userData['id']?.toString() ?? '',
            'email': userData['email'] ?? '',
            'name': userData['name'] ?? '',
            'lastName': userData['lastName'] ?? '',
          });
          
          await _storage.write(
            key: 'user_profile',
            value: jsonEncode(userData),
          );
        }
      }

      return {
        'success': true,
        'message': responseData['message'] ?? 'Registration successful',
        'data': data,
      };
    } on DioException catch (e) {
      String message = 'Registration failed';
      dynamic errorData;
      
      if (e.response?.data != null && e.response?.data is Map) {
        message = e.response?.data['message'] ?? message;
        errorData = e.response?.data;
      }
      
      return {
        'success': false,
        'message': message,
        'error': errorData ?? e.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
        'error': e.toString(),
      };
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } catch (e) {
      debugPrint('Error during logout: $e');
    } finally {
      await _clearAuthData();
      _userProvider.clearUser();
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking login status: $e');
      return false;
    }
  }
  
  @override
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  @override
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final profileData = await _storage.read(key: 'user_profile');
      if (profileData != null) {
        return jsonDecode(profileData) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }
}

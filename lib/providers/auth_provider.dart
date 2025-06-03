import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api/auth_service.dart';
import '../models/auth_error_response.dart';
import 'user_provider.dart';

/// Provider that handles authentication state and operations
class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final UserProvider? _userProvider;

  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService, this._userProvider);

  /// Whether the user is currently logged in
  bool get isLoggedIn => _userProvider?.user != null;

  /// Whether an authentication operation is in progress
  bool get isLoading => _isLoading;

  /// The last authentication error that occurred, if any
  String? get error => _error;

  /// Alias for error to maintain compatibility with existing code
  String? get errorMessage => _error;

  /// Logs in a user with the given email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      if (response != null) {
        // Get user profile after successful login
        final userProfile = await _authService.getUserProfile();
        if (userProfile != null) {
          final userData = {
            'id': response.user.id,
            'email': response.user.email,
            'name': response.user.name,
            'lastName': userProfile['lastName'] ?? '',
            'age': userProfile['age'],
            'gender': userProfile['gender'],
          };
          
          // Update user provider if available
          if (_userProvider != null) {
            _userProvider!.setUserFromMap(userData);
          }
          
          return true;
        } else {
          _error = 'No se pudo cargar el perfil del usuario';
          return false;
        }
      }
      _error = 'Error desconocido al iniciar sesión';
      return false;
    } on AuthErrorResponse catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Error inesperado: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registers a new user with the provided information
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required int age,
    required String gender,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        email: email,
        password: password,
        name: name,
        lastName: lastName,
        age: age,
        gender: gender,
      );

      // If registration was successful, update the UserProvider
      if (_userProvider != null) {
        _userProvider!.setUserFromMap({
          'id': response.user.id,
          'email': email,
          'name': name,
          'lastName': lastName,
          'age': age,
          'gender': gender,
        });
      }
      
      debugPrint('Registro exitoso: $email');
      return true;
    } on AuthErrorResponse catch (e) {
      _error = e.message;
      debugPrint('Error de registro: ${e.message}');
      return false;
    } catch (e) {
      _error = 'Error inesperado durante el registro: $e';
      debugPrint('Error en AuthProvider.register: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the user's profile information
  Future<bool> updateProfile({
    required String name,
    required String lastName,
    required int age,
    required String gender,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Update in auth service if the method exists
      await _authService.updateProfile(
        name: name,
        lastName: lastName,
        age: age,
        gender: gender,
      );

      // Update local user data if user provider is available
      if (_userProvider != null) {
        _userProvider!.setUserFromMap({
          'name': name,
          'lastName': lastName,
          'age': age,
          'gender': gender,
        });
      }

      return true;
    } on AuthErrorResponse catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Error al actualizar el perfil: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logs out the current user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _userProvider?.clearUser();
    } catch (e) {
      debugPrint('Error during logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Checks if there's an active session
  Future<bool> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final userProfile = await _authService.getUserProfile();
        if (userProfile != null && _userProvider != null) {
          _userProvider!.setUserFromMap(userProfile);
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears any authentication errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

// === PROVIDER GLOBAL DE RIVERPOD ===
final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  final userProv = ref.watch(userProvider);
  final authService = AuthService();
  return AuthProvider(authService, userProv);
});

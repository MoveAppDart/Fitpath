import 'package:flutter/foundation.dart';
import '../services/api/auth_service.dart';
import 'user_provider.dart';

/// Provider that handles authentication state and operations
class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final UserProvider _userProvider;

  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _currentUser;

  AuthProvider(this._authService, this._userProvider);

  /// Whether the user is currently logged in
  bool get isLoggedIn => _userProvider.user != null;

  /// Whether an authentication operation is in progress
  bool get isLoading => _isLoading;

  /// The last authentication error that occurred, if any
  String? get error => _error;

  /// Alias for error to maintain compatibility with existing code
  String? get errorMessage => _error;

  /// The current user's data, if logged in
  Map<String, dynamic>? get currentUser => _currentUser;

  /// Logs in a user with the given email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Intenta hacer login
      final response = await _authService.login(email, password);

      if (response['success'] == true) {
        // Si el login fue exitoso, verificamos el estado de autenticación
        // para asegurarnos de que el UserProvider fue actualizado correctamente
        debugPrint('Login exitoso, usuario autenticado');
        debugPrint('Estado de _userProvider.user después del login: ${_userProvider.user}');
        debugPrint('Estado de isLoggedIn después del login: $isLoggedIn');
        
        // Si por alguna razón el usuario no está en el provider después del login exitoso,
        // intentamos actualizarlo forzadamente
        if (_userProvider.user == null && response['data'] != null) {
          final data = response['data'] as Map<String, dynamic>;
          if (data['user'] != null && data['user'] is Map<String, dynamic>) {
            debugPrint('Actualizando UserProvider manualmente desde AuthProvider');
            _userProvider.setUserFromMap(data['user'] as Map<String, dynamic>);
            debugPrint('Estado de _userProvider.user después de actualización manual: ${_userProvider.user}');
          }
        }
        
        return true;
      } else {
        // Si hay un mensaje de error, lo mostramos
        _error = response['message'] ?? 'Error de autenticación';
        if (response['error'] != null) {
          _error = '$_error\n${response['error']}';
        }
        return false;
      }
    } catch (e) {
      _error = 'Error durante el inicio de sesión: $e';
      debugPrint('Error en AuthProvider.login: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registers a new user with the given email, password, and name
  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(email, password, name);

      if (response['success'] == true) {
        // Verificar que los datos del usuario se hayan actualizado correctamente
        final data = response['data'] as Map<String, dynamic>?;
        if (data != null) {
          final userData = data['user'] as Map<String, dynamic>?;
          if (userData != null) {
            // Asegurarnos de que el UserProvider tenga los datos del usuario
            // y marcarlo como recién registrado
            _userProvider.setUserFromMap({
              'id': userData['id']?.toString() ?? '',
              'email': userData['email'] ?? '',
              'name': userData['name'] ?? '',
              'lastName': userData['lastName'] ?? '',
            }, isNewRegistration: true);
          }
        }
        
        debugPrint('Registro exitoso, usuario autenticado');
        return {'success': true};
      } else {
        // Extraer el código de error y el mensaje si están disponibles
        final errorCode = response['statusCode'];
        final errorType = response['error'];
        final errorMessage = response['message'] ?? 'Error en el registro';
        
        // Formatear el mensaje de error
        _error = errorMessage;
        
        // Detectar específicamente el error de correo ya registrado
        bool isEmailExists = false;
        if (errorCode == 409 || (errorType is String && errorType == 'user_exists')) {
          isEmailExists = true;
          _error = 'El correo electrónico ya está registrado. Por favor utiliza otro correo o inicia sesión.';
        }
        
        debugPrint('Error en registro: $_error (Código: $errorCode, Tipo: $errorType)');
        return {
          'success': false, 
          'errorCode': errorCode, 
          'errorType': errorType,
          'message': _error,
          'isEmailExists': isEmailExists
        };
      }
    } catch (e) {
      debugPrint('Excepción en AuthProvider.register: $e');
      
      // Intentar detectar error 409 en la excepción
      bool isEmailExists = false;
      String errorMessage = 'Error durante el registro';
      
      if (e.toString().contains('409') || e.toString().contains('user_exists')) {
        isEmailExists = true;
        errorMessage = 'El correo electrónico ya está registrado. Por favor utiliza otro correo o inicia sesión.';
      } else {
        errorMessage = 'Error durante el registro: $e';
      }
      
      _error = errorMessage;
      return {
        'success': false, 
        'message': _error,
        'isEmailExists': isEmailExists
      };
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
      _currentUser = null;
      _userProvider.clearUser();
    } catch (e) {
      _error = 'Failed to log out: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Checks if the user is currently logged in
  Future<bool> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isAuthenticated = await _authService.isLoggedIn();
      if (isAuthenticated) {
        await _updateUserData();
      } else {
        _currentUser = null;
        _userProvider.clearUser();
      }
      return isAuthenticated;
    } catch (e) {
      _error = 'Failed to check authentication status: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the user data from the auth service
  Future<void> _updateUserData() async {
    try {
      debugPrint('Fetching user profile...');
      // Get the user profile from the auth service
      final profile = await _authService.getUserProfile();
      
      if (profile == null) {
        _error = 'No profile data received';
        debugPrint('Error: No profile data received from auth service');
        return;
      }
      
      debugPrint('Profile data received: $profile');
      
      // Update the current user in auth provider
      _currentUser = profile;
      
      try {
        // Check if the profile contains user data or just profile data
        if (profile.containsKey('user') && profile['user'] is Map<String, dynamic>) {
          // If we have a nested user object, use that
          debugPrint('Updating user from nested user object');
          _userProvider.setUserFromMap(profile['user'] as Map<String, dynamic>);
        } else if (profile.containsKey('userId') || profile.containsKey('email')) {
          // If we have a flat profile with user fields, use the whole profile
          debugPrint('Updating user from flat profile');
          _userProvider.setUserFromMap(profile);
        } else {
          debugPrint('Profile does not contain recognizable user data structure');
        }
        
        // Also update the profile data if available
        if (profile.containsKey('profile') && profile['profile'] is Map<String, dynamic>) {
          debugPrint('Updating additional profile data');
          _userProvider.updateProfile(profile['profile'] as Map<String, dynamic>);
        }
      } catch (e) {
        debugPrint('Error processing profile data: $e');
        rethrow;
      }
      
    } catch (e) {
      _error = 'Failed to fetch user profile: $e';
      debugPrint('Error in _updateUserData: $e');
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  /// Clears any authentication errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

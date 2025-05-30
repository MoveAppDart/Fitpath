import 'package:flutter/foundation.dart';
import '../services/api/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _lastLoginResponse;
  
  AuthProvider(this._authService) {
    _checkLoginStatus();
  }
  
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    
    _isLoggedIn = await _authService.isLoggedIn();
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    _lastLoginResponse = null;
    notifyListeners();
    
    try {
      final response = await _authService.login(email, password);
      _lastLoginResponse = response;
      
      if (response['success'] == true) {
        _isLoggedIn = true;
        return true;
      } else {
        _error = response['message'] ?? 'Error desconocido al iniciar sesión';
        _isLoggedIn = false;
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Getter para obtener el último mensaje de error específico
  String get errorMessage => _error ?? (_lastLoginResponse != null ? _lastLoginResponse!['message'] ?? 'Error desconocido' : 'Error desconocido');
  
  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final success = await _authService.register(email, password, name);
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}

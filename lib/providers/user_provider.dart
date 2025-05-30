import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService;
  User? _user;
  Map<String, dynamic>? _userPreferences;
  Map<String, dynamic>? _userStats;
  bool _isLoading = false;
  String? _error;
  
  UserProvider(this._userService);
  
  User? get user => _user;
  Map<String, dynamic>? get userPreferences => _userPreferences;
  Map<String, dynamic>? get userStats => _userStats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Carga el perfil del usuario desde la API
  Future<bool> loadUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _userService.getProfile();
      
      if (response['success'] == true) {
        final userData = response['data'];
        _user = User.fromJson(userData);
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al cargar el perfil';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Actualiza el perfil del usuario
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _userService.updateProfile(profileData);
      
      if (response['success'] == true) {
        // Si la actualización fue exitosa, actualizamos el perfil local
        if (_user != null) {
          _user = User.fromJson({...(_user!.toJson()), ...profileData});
        }
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al actualizar el perfil';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Carga las preferencias del usuario
  Future<bool> loadUserPreferences() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _userService.getUserPreferences();
      
      if (response['success'] == true) {
        _userPreferences = response['data'];
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al cargar preferencias';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Actualiza las preferencias del usuario
  Future<bool> updateUserPreferences(Map<String, dynamic> preferences) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _userService.updateUserPreferences(preferences);
      
      if (response['success'] == true) {
        _userPreferences = {...?_userPreferences, ...preferences};
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al actualizar preferencias';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Carga las estadísticas del usuario
  Future<bool> loadUserStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _userService.getUserStats();
      
      if (response['success'] == true) {
        _userStats = response['data'];
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al cargar estadísticas';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Limpia los datos del usuario (útil para cierre de sesión)
  void clearUserData() {
    _user = null;
    _userPreferences = null;
    _userStats = null;
    _error = null;
    notifyListeners();
  }
}

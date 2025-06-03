import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/profile.dart';
import '../services/api/user_service.dart';

/// Provider that manages user-related state and operations
class UserProvider with ChangeNotifier {
  final UserService _userService;

  User? _user;
  Profile? _profile;
  Map<String, dynamic>? _userPreferences;
  Map<String, dynamic>? _userStats;
  bool _isLoading = false;
  String? _error;
  bool _isNewlyRegistered = false; // Indica si el usuario acaba de registrarse

  UserProvider(this._userService);

  /// The current user, or null if not logged in
  User? get user => _user;

  /// The current user's profile, or null if not available
  Profile? get profile => _profile;

  /// The current user's preferences
  Map<String, dynamic>? get userPreferences => _userPreferences;

  /// The current user's statistics
  Map<String, dynamic>? get userStats => _userStats;

  /// Whether a user-related operation is in progress
  bool get isLoading => _isLoading;

  /// The last error that occurred, if any
  String? get error => _error;

  /// The current user's ID, or null if not logged in
  String? get userId => _user?.id;

  /// Whether a user is currently logged in
  bool get isLoggedIn => _user != null;

  /// Whether the user has just registered and needs to complete profile setup
  bool get isNewlyRegistered => _isNewlyRegistered;

  /// Updates the current user with the provided user data
  void setUser(User user, {bool isNewRegistration = false}) {
    _user = user;
    _isNewlyRegistered = isNewRegistration;
    notifyListeners();
  }

  /// Clears all user data (used on logout)
  void clearUser() {
    _user = null;
    _profile = null;
    _userPreferences = null;
    _userStats = null;
    _error = null;
    _isNewlyRegistered = false;
    notifyListeners();
  }

  /// Sets the user from a map of user data
  void setUserFromMap(Map<String, dynamic> userData,
      {bool isNewRegistration = false}) {
    debugPrint(
        'Setting user from map: $userData (isNewRegistration: $isNewRegistration)');
    try {
      debugPrint('UserProvider.setUserFromMap: $userData');

      // Verificar si hay campos esenciales
      if (!userData.containsKey('id')) {
        debugPrint('Advertencia: userData no contiene id');
      }
      if (!userData.containsKey('email')) {
        debugPrint('Advertencia: userData no contiene email');
      }
      if (!userData.containsKey('name')) {
        debugPrint('Advertencia: userData no contiene name');
      }

      // Asegurar que los campos esenciales existan y sean Strings
      Map<String, dynamic> processedData = {};
      processedData['id'] = userData['id']?.toString() ?? '';
      processedData['email'] = userData['email']?.toString() ?? '';
      processedData['name'] = userData['name']?.toString() ?? 'Usuario';
      processedData['lastName'] = userData['lastName']?.toString() ?? '';

      // Copiar otros campos que podrían existir
      for (final key in userData.keys) {
        if (!processedData.containsKey(key) && userData[key] != null) {
          processedData[key] = userData[key];
        }
      }

      debugPrint('Creando User desde: $processedData');
      _user = User.fromJson(processedData);
      debugPrint('User creado: ${_user?.toString()}');

      // Si los datos de usuario incluyen información de perfil, extraerla
      if (userData['profile'] is Map<String, dynamic>) {
        _profile = Profile.fromJson(userData['profile']);
        debugPrint('Perfil extraído de userData');
      }

      // Actualizar el estado de registro si es un usuario recién registrado
      // o si no tiene perfil completo con datos esenciales
      bool hasCompleteProfile = userData.containsKey('profile') &&
          userData['profile'] != null &&
          userData['profile'] is Map<String, dynamic> &&
          (userData['profile'] as Map<String, dynamic>).containsKey('weight') &&
          (userData['profile'] as Map<String, dynamic>).containsKey('height') &&
          (userData['profile'] as Map<String, dynamic>)
              .containsKey('fitnessGoals');

      _isNewlyRegistered = isNewRegistration || !hasCompleteProfile;
      debugPrint(
          'Usuario estado: isNewlyRegistered=$_isNewlyRegistered (hasCompleteProfile=$hasCompleteProfile)');

      notifyListeners();
      debugPrint(
          'Estado de usuario actualizado, isLoggedIn ahora es: $isLoggedIn');
    } catch (e) {
      debugPrint('Error al parsear datos de usuario: $e');
      _error = 'Failed to parse user data: $e';
      // No relanzamos la excepción para evitar que se interrumpa el flujo
      // Solo registramos el error y dejamos que la aplicación continúe
    }
  }

  /// Marca al usuario como que ya ha completado el proceso de registro inicial
  void completeRegistration() {
    _isNewlyRegistered = false;
    notifyListeners();
  }

  /// Loads the user's profile from the API
  Future<bool> loadUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _userService.getProfile();

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;

        // Update user data if available
        if (data['user'] is Map<String, dynamic>) {
          _user = User.fromJson(data['user'] as Map<String, dynamic>);
        }

        // Update profile data if available
        if (data['profile'] is Map<String, dynamic>) {
          _profile = Profile.fromJson(data['profile'] as Map<String, dynamic>);
        }

        // Update preferences and stats if available
        _userPreferences = data['preferences'] as Map<String, dynamic>?;
        _userStats = data['stats'] as Map<String, dynamic>?;

        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to load profile';
        return false;
      }
    } catch (e) {
      _error = 'Error loading profile: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the user's profile
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _userService.updateProfile(profileData);

      if (response['success'] == true && response['data'] != null) {
        // Reload the profile to get the updated data
        return await loadUserProfile();
      } else {
        _error = response['message'] ?? 'Failed to update profile';
        return false;
      }
    } catch (e) {
      _error = 'Error updating profile: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the user's preferences
  Future<bool> updatePreferences(Map<String, dynamic> preferences) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _userService.updatePreferences(preferences);

      if (response['success'] == true) {
        _userPreferences = {
          ...?_userPreferences,
          ...preferences,
        };
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to update preferences';
        return false;
      }
    } catch (e) {
      _error = 'Error updating preferences: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears any error messages
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

// === PROVIDER GLOBAL DE RIVERPOD ===
final userProvider = ChangeNotifierProvider<UserProvider>((ref) {
  final userService = UserService(); // Ajusta aquí si requiere argumentos
  return UserProvider(userService);
});

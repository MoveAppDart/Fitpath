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
      // First, attempt to login
      final response = await _authService.login(email, password);

      if (response['success'] == true) {
        // If login is successful, try to fetch user profile
        try {
          await _updateUserData();
          return true;
        } catch (profileError) {
          debugPrint('Error updating user data: $profileError');
          // Even if profile fetch fails, we can still consider login successful
          // as long as we have a valid token
          final token = await _authService.getToken();
          if (token != null) {
            _error = 'Logged in, but could not load profile. ${profileError.toString()}';
            return true;
          }
          _error = 'Login successful but no authentication token was received';
          return false;
        }
      } else {
        _error = response['message'] ?? 'Authentication failed';
        if (response['error'] != null) {
          _error = '${_error}\n${response['error']}';
        }
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

  /// Registers a new user with the given email, password, and name
  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(email, password, name);

      if (response['success'] == true) {
        // Update user data from the response
        await _updateUserData();
        return true;
      } else {
        _error = response['message'] ?? 'Registration failed';
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

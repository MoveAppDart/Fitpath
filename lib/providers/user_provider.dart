import 'package:flutter/foundation.dart';
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
  
  /// Clears all user data (used on logout)
  void clearUser() {
    _user = null;
    _profile = null;
    _userPreferences = null;
    _userStats = null;
    _error = null;
    notifyListeners();
  }
  
  /// Sets the user from a map of user data
  void setUserFromMap(Map<String, dynamic> userData) {
    try {
      _user = User.fromJson(userData);
      
      // If the user data includes profile information, extract it
      if (userData['profile'] is Map<String, dynamic>) {
        _profile = Profile.fromJson(userData['profile']);
      }
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to parse user data: $e';
      rethrow;
    }
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

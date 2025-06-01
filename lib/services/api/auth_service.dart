
import 'dart:async';

/// Interface defining the required methods for the authentication service
abstract class AuthService {
  /// Logs in a user with email and password
  ///
  /// Returns a Map with fields: success, message, data
  Future<Map<String, dynamic>> login(String email, String password);

  /// Registers a new user with email, password, and name
  ///
  /// Returns a Map with fields: success, message, data
  Future<Map<String, dynamic>> register(String email, String password, String name);

  /// Logs out the current user
  ///
  /// Clears stored tokens and makes a request to the logout endpoint if it exists
  Future<void> logout();

  /// Checks if a user is currently logged in
  ///
  /// Returns true if there is a stored auth token
  Future<bool> isLoggedIn();
  
  /// Gets the current authentication token
  ///
  /// Returns the JWT token if available, null otherwise
  Future<String?> getToken();
  
  /// Gets the current user's profile data
  ///
  /// Returns a Map containing the user's profile data if available
  Future<Map<String, dynamic>?> getUserProfile();
}

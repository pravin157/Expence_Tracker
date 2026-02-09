import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'expense_model.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;
  UserProfile? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  UserProfile? get currentUser => _currentUser;

  AuthProvider() {
    _initialize();
  }

  /// Initialize auth state by checking for saved token
  Future<void> _initialize() async {
    try {
      await _apiService.loadToken();
      if (_apiService.isAuthenticated) {
        // Try to fetch profile to validate token
        final profileData = await _apiService.getProfile();
        _currentUser = UserProfile.fromJson(profileData);
        _isAuthenticated = true;
      }
    } catch (e) {
      // Token is invalid or expired
      await _apiService.clearToken();
      _isAuthenticated = false;
      _currentUser = null;
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      if (response['user'] != null) {
        _currentUser = UserProfile.fromJson(response['user']);
      } else {
        // Fetch profile separately if not in response
        final profileData = await _apiService.getProfile();
        _currentUser = UserProfile.fromJson(profileData);
      }

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage =
          'Connection error. Please check your internet connection.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Client-side validation
    if (name.trim().isEmpty) {
      _errorMessage = 'Please enter your name';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final response = await _apiService.register(
        name: name,
        email: email,
        password: password,
      );

      if (response['user'] != null) {
        _currentUser = UserProfile.fromJson(response['user']);
      } else {
        _currentUser = UserProfile(
          name: name,
          email: email,
          joinDate: DateTime.now(),
        );
      }

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage =
          'Connection error. Please check your internet connection.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    _isAuthenticated = false;
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> updateProfile({String? name, String? email}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.updateProfile(
        name: name,
        email: email,
      );

      _currentUser = UserProfile.fromJson(response);
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update profile';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (newPassword.length < 6) {
      _errorMessage = 'New password must be at least 6 characters';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      await _apiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to change password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshProfile() async {
    try {
      final profileData = await _apiService.getProfile();
      _currentUser = UserProfile.fromJson(profileData);
      notifyListeners();
    } catch (e) {
      // Handle silently or log error
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

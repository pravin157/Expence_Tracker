import 'package:flutter/foundation.dart';
import 'expense_model.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  UserProfile? _currentUser;

  // Simulated user database
  final Map<String, Map<String, String>> _users = {};

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserProfile? get currentUser => _currentUser;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Check if user exists
    if (_users.containsKey(email)) {
      if (_users[email]!['password'] == password) {
        _currentUser = UserProfile(
          name: _users[email]!['name']!,
          email: email,
          joinDate: DateTime.now(),
        );
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Incorrect password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } else {
      // For demo purposes, allow login with any credentials
      _currentUser = UserProfile(
        name: email.split('@').first,
        email: email,
        joinDate: DateTime.now(),
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Check if email already exists
    if (_users.containsKey(email)) {
      _errorMessage = 'An account with this email already exists';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Validate inputs
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

    // Register user
    _users[email] = {
      'name': name,
      'password': password,
    };

    // Auto-login after registration
    _currentUser = UserProfile(
      name: name,
      email: email,
      joinDate: DateTime.now(),
    );
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

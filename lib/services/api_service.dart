import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  // TODO: Update this to your server URL
  static const String baseUrl = 'http://expense.kray:8000/api/v1';

  String? _token;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  String? get token => _token;
  bool get isAuthenticated => _token != null;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // ============ AUTH ENDPOINTS ============

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (data['access_token'] != null) {
        await _saveToken(data['access_token']);
      }
      return data;
    } else {
      throw ApiException(
        data['detail'] ?? 'Registration failed',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['access_token'] != null) {
        await _saveToken(data['access_token']);
      }
      return data;
    } else {
      throw ApiException(
        data['detail'] ?? 'Login failed',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw ApiException(
        'Session expired. Please login again.',
        statusCode: 401,
      );
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to get profile',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;

    final response = await http.put(
      Uri.parse('$baseUrl/auth/me'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to update profile',
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final uri = Uri.parse('$baseUrl/auth/change-password').replace(
      queryParameters: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );

    final response = await http.post(uri, headers: _headers);

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to change password',
        statusCode: response.statusCode,
      );
    }
  }

  // ============ EXPENSE ENDPOINTS ============

  Future<Map<String, dynamic>> createExpense({
    required double amount,
    required String category,
    String? description,
    DateTime? date,
  }) async {
    final body = <String, dynamic>{'amount': amount, 'category': category};
    if (description != null) body['description'] = description;
    if (date != null) body['date'] = date.toIso8601String();

    final response = await http.post(
      Uri.parse('$baseUrl/expenses/'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to create expense',
        statusCode: response.statusCode,
      );
    }
  }

  Future<List<dynamic>> getExpenses({
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    int skip = 0,
    int limit = 50,
  }) async {
    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };
    if (category != null) queryParams['category'] = category;
    if (startDate != null)
      queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
    if (minAmount != null) queryParams['min_amount'] = minAmount.toString();
    if (maxAmount != null) queryParams['max_amount'] = maxAmount.toString();

    final uri = Uri.parse(
      '$baseUrl/expenses/',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to get expenses',
        statusCode: response.statusCode,
      );
    }
  }

  Future<List<dynamic>> getRecentExpenses({int limit = 5}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/expenses/recent?limit=$limit'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to get recent expenses',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final response = await http.get(
      Uri.parse('$baseUrl/expenses/statistics'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to get statistics',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> getExpense(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/expenses/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to get expense',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> updateExpense(
    String id, {
    double? amount,
    String? category,
    String? description,
    DateTime? date,
  }) async {
    final body = <String, dynamic>{};
    if (amount != null) body['amount'] = amount;
    if (category != null) body['category'] = category;
    if (description != null) body['description'] = description;
    if (date != null) body['date'] = date.toIso8601String();

    final response = await http.put(
      Uri.parse('$baseUrl/expenses/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to update expense',
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> deleteExpense(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/expenses/$id'),
      headers: _headers,
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to delete expense',
        statusCode: response.statusCode,
      );
    }
  }

  Future<List<dynamic>> getExpensesByCategory(
    String category, {
    int skip = 0,
    int limit = 50,
  }) async {
    final uri = Uri.parse('$baseUrl/expenses/category/$category').replace(
      queryParameters: {'skip': skip.toString(), 'limit': limit.toString()},
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to get expenses by category',
        statusCode: response.statusCode,
      );
    }
  }

  // ============ LIMITS ENDPOINTS ============

  Future<Map<String, dynamic>> getLimits() async {
    final response = await http.get(
      Uri.parse('$baseUrl/limits/'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to get limits',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> updateLimits({
    double? monthlyLimit,
    double? yearlyLimit,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/limits/'),
      headers: _headers,
      body: jsonEncode({
        'monthly_limit': monthlyLimit,
        'yearly_limit': yearlyLimit,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to update limits',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> getBudgetStatus() async {
    final response = await http.get(
      Uri.parse('$baseUrl/limits/status'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to get budget status',
        statusCode: response.statusCode,
      );
    }
  }

  // ============ DASHBOARD ENDPOINT ============

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(
        data['detail'] ?? 'Failed to get dashboard',
        statusCode: response.statusCode,
      );
    }
  }
}

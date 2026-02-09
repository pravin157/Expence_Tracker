import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'expense_model.dart';

class ExpenseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Expense> _expenses = [];
  ExpenseLimit? _monthlyLimit;
  ExpenseLimit? _yearlyLimit;
  ExpenseStatistics? _statistics;
  BudgetStatus? _budgetStatus;

  bool _isLoading = false;
  String? _errorMessage;

  List<Expense> get expenses => _expenses;
  ExpenseLimit? get monthlyLimit => _monthlyLimit;
  ExpenseLimit? get yearlyLimit => _yearlyLimit;
  ExpenseStatistics? get statistics => _statistics;
  BudgetStatus? get budgetStatus => _budgetStatus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalExpenses =>
      _statistics?.totalExpenses ??
      _expenses.fold(0, (sum, expense) => sum + expense.amount);

  double get monthlyExpenses =>
      _statistics?.monthlyExpenses ?? _calculateMonthlyExpenses();

  double get yearlyExpenses =>
      _statistics?.yearlyExpenses ?? _calculateYearlyExpenses();

  Map<ExpenseCategory, double> get expensesByCategory {
    if (_statistics != null && _statistics!.categoryBreakdown.isNotEmpty) {
      final map = <ExpenseCategory, double>{};
      for (var breakdown in _statistics!.categoryBreakdown) {
        map[breakdown.category] = breakdown.total;
      }
      return map;
    }
    return _calculateExpensesByCategory();
  }

  double _calculateMonthlyExpenses() {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  double _calculateYearlyExpenses() {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  Map<ExpenseCategory, double> _calculateExpensesByCategory() {
    final map = <ExpenseCategory, double>{};
    for (var category in ExpenseCategory.values) {
      map[category] = _expenses
          .where((e) => e.category == category)
          .fold(0, (sum, expense) => sum + expense.amount);
    }
    return map;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Load all data from API
  Future<void> loadAllData() async {
    await Future.wait([
      loadExpenses(),
      loadStatistics(),
      loadLimits(),
      loadBudgetStatus(),
    ]);
  }

  /// Load expenses from API
  Future<void> loadExpenses({
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    int limit = 50,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getExpenses(
        category: category,
        startDate: startDate,
        endDate: endDate,
        minAmount: minAmount,
        maxAmount: maxAmount,
        limit: limit,
      );

      _expenses = response.map((json) => Expense.fromJson(json)).toList();
      _errorMessage = null;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load expenses';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load recent expenses from API
  Future<List<Expense>> loadRecentExpenses({int limit = 5}) async {
    try {
      final response = await _apiService.getRecentExpenses(limit: limit);
      return response.map((json) => Expense.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Load statistics from API
  Future<void> loadStatistics() async {
    try {
      final response = await _apiService.getStatistics();
      _statistics = ExpenseStatistics.fromJson(response);
      notifyListeners();
    } catch (e) {
      // Handle silently or log error
    }
  }

  /// Load limits from API
  Future<void> loadLimits() async {
    try {
      final response = await _apiService.getLimits();
      _monthlyLimit = ExpenseLimit.fromLimitsResponse(response, 'monthly');
      _yearlyLimit = ExpenseLimit.fromLimitsResponse(response, 'yearly');
      notifyListeners();
    } catch (e) {
      // Handle silently - user may not have limits set
    }
  }

  /// Load budget status from API
  Future<void> loadBudgetStatus() async {
    try {
      final response = await _apiService.getBudgetStatus();
      _budgetStatus = BudgetStatus.fromJson(response);
      notifyListeners();
    } catch (e) {
      // Handle silently
    }
  }

  /// Add a new expense
  Future<bool> addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    DateTime? date,
    String? description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.createExpense(
        amount: amount,
        category: category.toApiString(),
        description: description ?? title,
        date: date,
      );

      final newExpense = Expense.fromJson(response);
      _expenses.insert(0, newExpense);

      // Refresh statistics after adding expense
      await loadStatistics();
      await loadBudgetStatus();

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to add expense';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update an existing expense
  Future<bool> updateExpense(
    String id, {
    String? title,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.updateExpense(
        id,
        amount: amount,
        category: category?.toApiString(),
        description: description ?? title,
        date: date,
      );

      final updatedExpense = Expense.fromJson(response);
      final index = _expenses.indexWhere((e) => e.id == id);
      if (index != -1) {
        _expenses[index] = updatedExpense;
      }

      // Refresh statistics after updating expense
      await loadStatistics();

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update expense';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Remove an expense
  Future<bool> removeExpense(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteExpense(id);
      _expenses.removeWhere((e) => e.id == id);

      // Refresh statistics after deleting expense
      await loadStatistics();
      await loadBudgetStatus();

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete expense';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Set monthly spending limit
  Future<bool> setMonthlyLimit(double amount) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.updateLimits(
        monthlyLimit: amount,
        yearlyLimit: _yearlyLimit?.limitAmount,
      );

      _monthlyLimit = ExpenseLimit.fromLimitsResponse(response, 'monthly');
      _yearlyLimit = ExpenseLimit.fromLimitsResponse(response, 'yearly');

      await loadBudgetStatus();

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to set monthly limit';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Set yearly spending limit
  Future<bool> setYearlyLimit(double amount) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.updateLimits(
        monthlyLimit: _monthlyLimit?.limitAmount,
        yearlyLimit: amount,
      );

      _monthlyLimit = ExpenseLimit.fromLimitsResponse(response, 'monthly');
      _yearlyLimit = ExpenseLimit.fromLimitsResponse(response, 'yearly');

      await loadBudgetStatus();

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to set yearly limit';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Set both limits at once
  Future<bool> setLimits({double? monthlyLimit, double? yearlyLimit}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.updateLimits(
        monthlyLimit: monthlyLimit,
        yearlyLimit: yearlyLimit,
      );

      _monthlyLimit = ExpenseLimit.fromLimitsResponse(response, 'monthly');
      _yearlyLimit = ExpenseLimit.fromLimitsResponse(response, 'yearly');

      await loadBudgetStatus();

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to set limits';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool isMonthlyLimitExceeded() {
    if (_budgetStatus != null) {
      return _budgetStatus!.monthlyStatus == 'exceeded';
    }
    if (_monthlyLimit == null) return false;
    return monthlyExpenses > _monthlyLimit!.limitAmount;
  }

  bool isYearlyLimitExceeded() {
    if (_budgetStatus != null) {
      return _budgetStatus!.yearlyStatus == 'exceeded';
    }
    if (_yearlyLimit == null) return false;
    return yearlyExpenses > _yearlyLimit!.limitAmount;
  }

  double getMonthlyLimitRemaining() {
    if (_budgetStatus != null) {
      return (_budgetStatus!.monthlyLimit - _budgetStatus!.monthlySpent).clamp(
        0,
        double.infinity,
      );
    }
    if (_monthlyLimit == null) return 0;
    return (_monthlyLimit!.limitAmount - monthlyExpenses).clamp(
      0,
      double.infinity,
    );
  }

  double getYearlyLimitRemaining() {
    if (_budgetStatus != null) {
      return (_budgetStatus!.yearlyLimit - _budgetStatus!.yearlySpent).clamp(
        0,
        double.infinity,
      );
    }
    if (_yearlyLimit == null) return 0;
    return (_yearlyLimit!.limitAmount - yearlyExpenses).clamp(
      0,
      double.infinity,
    );
  }

  double getMonthlyLimitPercentage() {
    if (_budgetStatus != null) {
      return _budgetStatus!.monthlyPercentage;
    }
    if (_monthlyLimit == null || _monthlyLimit!.limitAmount == 0) return 0;
    return (monthlyExpenses / _monthlyLimit!.limitAmount * 100).clamp(0, 100);
  }

  double getYearlyLimitPercentage() {
    if (_budgetStatus != null) {
      return _budgetStatus!.yearlyPercentage;
    }
    if (_yearlyLimit == null || _yearlyLimit!.limitAmount == 0) return 0;
    return (yearlyExpenses / _yearlyLimit!.limitAmount * 100).clamp(0, 100);
  }

  List<String> getAlerts() {
    return _budgetStatus?.alerts ?? [];
  }

  /// Load dashboard data (combined endpoint)
  Future<Map<String, dynamic>?> loadDashboard() async {
    try {
      final response = await _apiService.getDashboard();

      // Parse statistics
      if (response['statistics'] != null) {
        _statistics = ExpenseStatistics.fromJson(response['statistics']);
      }

      // Parse recent expenses
      if (response['recent_expenses'] != null) {
        _expenses = (response['recent_expenses'] as List)
            .map((json) => Expense.fromJson(json))
            .toList();
      }

      // Parse limits
      if (response['limits'] != null) {
        _monthlyLimit = ExpenseLimit.fromLimitsResponse(
          response['limits'],
          'monthly',
        );
        _yearlyLimit = ExpenseLimit.fromLimitsResponse(
          response['limits'],
          'yearly',
        );
      }

      notifyListeners();
      return response;
    } catch (e) {
      return null;
    }
  }

  /// Clear all local data (call on logout)
  void clearData() {
    _expenses = [];
    _monthlyLimit = null;
    _yearlyLimit = null;
    _statistics = null;
    _budgetStatus = null;
    _errorMessage = null;
    notifyListeners();
  }
}

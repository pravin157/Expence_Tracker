import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'expense_model.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [
    // Sample data
    Expense(
      id: '1',
      title: 'Lunch at Restaurant',
      amount: 25.50,
      category: ExpenseCategory.food,
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Lunch with friends',
    ),
    Expense(
      id: '2',
      title: 'Taxi fare',
      amount: 12.00,
      category: ExpenseCategory.transport,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Expense(
      id: '3',
      title: 'Movie ticket',
      amount: 15.00,
      category: ExpenseCategory.entertainment,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Expense(
      id: '4',
      title: 'Grocery shopping',
      amount: 65.30,
      category: ExpenseCategory.shopping,
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  ExpenseLimit? _monthlyLimit;
  ExpenseLimit? _yearlyLimit;

  UserProfile? _userProfile;

  List<Expense> get expenses => _expenses;
  ExpenseLimit? get monthlyLimit => _monthlyLimit;
  ExpenseLimit? get yearlyLimit => _yearlyLimit;
  UserProfile? get userProfile =>
      _userProfile ??
      UserProfile(
        name: 'John Doe',
        email: 'john@example.com',
        joinDate: DateTime.now(),
      );

  double get totalExpenses =>
      _expenses.fold(0, (sum, expense) => sum + expense.amount);

  double get monthlyExpenses {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  double get yearlyExpenses {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  Map<ExpenseCategory, double> get expensesByCategory {
    final map = <ExpenseCategory, double>{};
    for (var category in ExpenseCategory.values) {
      map[category] = _expenses
          .where((e) => e.category == category)
          .fold(0, (sum, expense) => sum + expense.amount);
    }
    return map;
  }

  void addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    DateTime? date,
    String? description,
  }) {
    final expense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: date ?? DateTime.now(),
      description: description,
    );
    _expenses.insert(0, expense);
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void setMonthlyLimit(double amount) {
    _monthlyLimit = ExpenseLimit(
      period: 'monthly',
      limitAmount: amount,
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  void setYearlyLimit(double amount) {
    _yearlyLimit = ExpenseLimit(
      period: 'yearly',
      limitAmount: amount,
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  void updateUserProfile({
    required String name,
    required String email,
    String? profileImage,
  }) {
    _userProfile = UserProfile(
      name: name,
      email: email,
      profileImage: profileImage,
      joinDate: _userProfile?.joinDate ?? DateTime.now(),
    );
    notifyListeners();
  }

  bool isMonthlyLimitExceeded() {
    if (_monthlyLimit == null) return false;
    return monthlyExpenses > _monthlyLimit!.limitAmount;
  }

  bool isYearlyLimitExceeded() {
    if (_yearlyLimit == null) return false;
    return yearlyExpenses > _yearlyLimit!.limitAmount;
  }

  double getMonthlyLimitRemaining() {
    if (_monthlyLimit == null) return 0;
    return (_monthlyLimit!.limitAmount - monthlyExpenses).clamp(0, double.infinity);
  }

  double getYearlyLimitRemaining() {
    if (_yearlyLimit == null) return 0;
    return (_yearlyLimit!.limitAmount - yearlyExpenses).clamp(0, double.infinity);
  }
}

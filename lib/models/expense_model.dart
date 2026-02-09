enum ExpenseCategory {
  food('Food', '🍔'),
  transport('Transport', '🚗'),
  entertainment('Entertainment', '🎬'),
  shopping('Shopping', '🛍️'),
  utilities('Utilities', '⚡'),
  health('Health', '🏥'),
  education('Education', '📚'),
  other('Other', '📌');

  final String label;
  final String emoji;

  const ExpenseCategory(this.label, this.emoji);

  /// Convert category to API string format
  String toApiString() => name.toLowerCase();

  /// Create category from API string
  static ExpenseCategory fromApiString(String value) {
    return ExpenseCategory.values.firstWhere(
      (c) => c.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ExpenseCategory.other,
    );
  }
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? description;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  /// Create Expense from API JSON response
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? '',
      // API uses 'description' field which we map to title
      title: json['description'] ?? 'Expense',
      amount: (json['amount'] as num).toDouble(),
      category: ExpenseCategory.fromApiString(json['category'] ?? 'other'),
      date: DateTime.parse(json['date']),
      description: json['description'],
      userId: json['user_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Convert Expense to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category.toApiString(),
      'description': description ?? title,
      'date': date.toIso8601String(),
    };
  }

  /// Create a copy of expense with updated fields
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? description,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ExpenseLimit {
  final String? id;
  final String? userId;
  final String period; // 'monthly' or 'yearly'
  final double limitAmount;
  final double spent;
  final double remaining;
  final bool exceeded;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ExpenseLimit({
    this.id,
    this.userId,
    required this.period,
    required this.limitAmount,
    this.spent = 0,
    this.remaining = 0,
    this.exceeded = false,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create limits from API response
  factory ExpenseLimit.fromLimitsResponse(
    Map<String, dynamic> json,
    String period,
  ) {
    if (period == 'monthly') {
      return ExpenseLimit(
        id: json['id'],
        userId: json['user_id'],
        period: 'monthly',
        limitAmount: (json['monthly_limit'] as num?)?.toDouble() ?? 0,
        spent: (json['monthly_spent'] as num?)?.toDouble() ?? 0,
        remaining: (json['monthly_remaining'] as num?)?.toDouble() ?? 0,
        exceeded: json['monthly_exceeded'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
      );
    } else {
      return ExpenseLimit(
        id: json['id'],
        userId: json['user_id'],
        period: 'yearly',
        limitAmount: (json['yearly_limit'] as num?)?.toDouble() ?? 0,
        spent: (json['yearly_spent'] as num?)?.toDouble() ?? 0,
        remaining: (json['yearly_remaining'] as num?)?.toDouble() ?? 0,
        exceeded: json['yearly_exceeded'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
      );
    }
  }
}

class BudgetStatus {
  final double monthlyLimit;
  final double yearlyLimit;
  final double monthlySpent;
  final double yearlySpent;
  final double monthlyPercentage;
  final double yearlyPercentage;
  final String monthlyStatus;
  final String yearlyStatus;
  final List<String> alerts;
  final List<String> recommendations;

  BudgetStatus({
    required this.monthlyLimit,
    required this.yearlyLimit,
    required this.monthlySpent,
    required this.yearlySpent,
    required this.monthlyPercentage,
    required this.yearlyPercentage,
    required this.monthlyStatus,
    required this.yearlyStatus,
    required this.alerts,
    required this.recommendations,
  });

  factory BudgetStatus.fromJson(Map<String, dynamic> json) {
    return BudgetStatus(
      monthlyLimit: (json['monthly_limit'] as num?)?.toDouble() ?? 0,
      yearlyLimit: (json['yearly_limit'] as num?)?.toDouble() ?? 0,
      monthlySpent: (json['monthly_spent'] as num?)?.toDouble() ?? 0,
      yearlySpent: (json['yearly_spent'] as num?)?.toDouble() ?? 0,
      monthlyPercentage: (json['monthly_percentage'] as num?)?.toDouble() ?? 0,
      yearlyPercentage: (json['yearly_percentage'] as num?)?.toDouble() ?? 0,
      monthlyStatus: json['monthly_status'] ?? 'no_limit',
      yearlyStatus: json['yearly_status'] ?? 'no_limit',
      alerts: List<String>.from(json['alerts'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}

class ExpenseStatistics {
  final double totalExpenses;
  final double monthlyExpenses;
  final double yearlyExpenses;
  final int totalTransactions;
  final int monthlyTransactions;
  final int yearlyTransactions;
  final List<CategoryBreakdown> categoryBreakdown;
  final List<CategoryBreakdown> topCategories;

  ExpenseStatistics({
    required this.totalExpenses,
    required this.monthlyExpenses,
    required this.yearlyExpenses,
    required this.totalTransactions,
    required this.monthlyTransactions,
    required this.yearlyTransactions,
    required this.categoryBreakdown,
    required this.topCategories,
  });

  factory ExpenseStatistics.fromJson(Map<String, dynamic> json) {
    return ExpenseStatistics(
      totalExpenses: (json['total_expenses'] as num?)?.toDouble() ?? 0,
      monthlyExpenses: (json['monthly_expenses'] as num?)?.toDouble() ?? 0,
      yearlyExpenses: (json['yearly_expenses'] as num?)?.toDouble() ?? 0,
      totalTransactions: (json['total_transactions'] as num?)?.toInt() ?? 0,
      monthlyTransactions: (json['monthly_transactions'] as num?)?.toInt() ?? 0,
      yearlyTransactions: (json['yearly_transactions'] as num?)?.toInt() ?? 0,
      categoryBreakdown:
          (json['category_breakdown'] as List<dynamic>?)
              ?.map((c) => CategoryBreakdown.fromJson(c))
              .toList() ??
          [],
      topCategories:
          (json['top_categories'] as List<dynamic>?)
              ?.map((c) => CategoryBreakdown.fromJson(c))
              .toList() ??
          [],
    );
  }
}

class CategoryBreakdown {
  final ExpenseCategory category;
  final double total;
  final double percentage;
  final int count;

  CategoryBreakdown({
    required this.category,
    required this.total,
    required this.percentage,
    required this.count,
  });

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdown(
      category: ExpenseCategory.fromApiString(json['category'] ?? 'other'),
      total: (json['total'] as num?)?.toDouble() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class UserProfile {
  final String? id;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime joinDate;
  final DateTime? updatedAt;

  UserProfile({
    this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.joinDate,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      joinDate: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    DateTime? joinDate,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      joinDate: joinDate ?? this.joinDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

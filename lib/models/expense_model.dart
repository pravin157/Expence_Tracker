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
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? description;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });
}

class ExpenseLimit {
  final String period; // 'monthly' or 'yearly'
  final double limitAmount;
  final DateTime createdAt;

  ExpenseLimit({
    required this.period,
    required this.limitAmount,
    required this.createdAt,
  });
}

class UserProfile {
  final String name;
  final String email;
  final String? profileImage;
  final DateTime joinDate;

  UserProfile({
    required this.name,
    required this.email,
    this.profileImage,
    required this.joinDate,
  });
}

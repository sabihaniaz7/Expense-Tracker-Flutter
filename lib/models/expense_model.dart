import 'package:hive/hive.dart';

part 'expense_model.g.dart';

/// Data models for persistable Expense and Monthly Income entries.
/// These models use Hive for storage and code generation for adapters.
/// Represents a single financial transaction (expense or income).
@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  late String note;

  @HiveField(6)
  late bool isIncome;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
    this.isIncome = false,
  });
}

/// Represents fixed monthly income for a specific month.
/// [monthKey] is formatted as "YYYY-MM".
@HiveType(typeId: 1)
class MonthlyIncome extends HiveObject {
  @HiveField(0)
  late String monthKey; // "2026-02"

  @HiveField(1)
  late double amount;

  MonthlyIncome({required this.monthKey, required this.amount});
}

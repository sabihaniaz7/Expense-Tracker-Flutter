import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final String note;
  @HiveField(6)
  final bool isIncome;

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
  @HiveType(typeId: 1)
class MonthlyIncome extends HiveObject {
  @HiveField(0)
  late String monthKey; // "2026-02"
 
  @HiveField(1)
  late double amount;
 
  MonthlyIncome({required this.monthKey, required this.amount});
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';
import 'package:intl/intl.dart';

class ExpenseProvider extends ChangeNotifier {
  late Box<Expense> _expenseBox;
  late Box<MonthlyIncome> _incomeBox;
  final _uuid = const Uuid();
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<void> init() async {
    _expenseBox = await Hive.openBox<Expense>('expenses');
    _incomeBox = await Hive.openBox<MonthlyIncome>('incomes');
    notifyListeners();
  }

  // Helper: Month key
  String monthKey(DateTime date) => DateFormat('yyyy-MM').format(date);
  String get currentMonthKey => monthKey(DateTime.now());

  // Get all Expenses for a specific month
  List<Expense> getExpenseForMonth(String mKey) {
    return _expenseBox.values
        .where((e) => !e.isIncome && monthKey(e.date) == mKey)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get current month expenses
  List<Expense> get currentMonthExpenses => getExpenseForMonth(currentMonthKey);
  // Get all expenses soeted by date
  List<Expense> get allExpenses {
    final list = _expenseBox.values.where((e) => !e.isIncome).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  // Monthly Income
  double getIncomeForMonth(String mKey) {
    try {
      return _incomeBox.values.firstWhere((e) => e.monthKey == mKey).amount;
    } catch (e) {
      return 0.0;
    }
  }

  double get currentMonthIncome => getIncomeForMonth(currentMonthKey);
  // Total expenses for month
  double getTotalExpensesForMonth(String mKey) {
    return getExpenseForMonth(mKey).fold(0.0, (sum, e) => sum + e.amount);
  }

  double get currentMonthTotalExpenses =>
      getTotalExpensesForMonth(currentMonthKey);
  // Remaining
  double get currentMonthRemaining =>
      currentMonthIncome - currentMonthTotalExpenses;
  // Used percentage
  double get usedPercentage {
    if (currentMonthIncome == 0) return 0;
    return (currentMonthTotalExpenses / currentMonthIncome) * 100;
  }

  // Warning level: 0=safe, 1=warning(yellow), 2=alert(orange), 3=danger(red)
  int get warningLevel {
    final pct = usedPercentage;
    if (pct >= 100) return 3;
    if (pct >= 90) return 2;
    if (pct >= 70) return 1;
    return 0;
  }
}

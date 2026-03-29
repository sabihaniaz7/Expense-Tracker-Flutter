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
  String monthKey(DtaeTime date)=>DateFormat('yyyy-MM').format(date);
  String get currentMonthKey=>monthKey(DateTime.now());
}

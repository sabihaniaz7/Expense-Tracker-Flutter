import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';
import 'package:intl/intl.dart';

/// Manages the application's state, data persistence, and business logic.
/// Central state management for the Expense Tracker.
/// Handles database operations, UI state (theme, selected month),
/// and financial calculations.
class ExpenseProvider extends ChangeNotifier {
  late Box<Expense> _expenseBox;
  late Box<MonthlyIncome> _incomeBox;
  final _uuid = const Uuid();
  bool _isDarkMode = true;
  String? _initializationError;

  bool get isDarkMode => _isDarkMode;
  String? get initializationError => _initializationError;

  set initializationError(String? value) {
    _initializationError = value;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Which month the dasboard is currently viewing
  // null = current month. Stored here so it survives screen navigation.
  String? _dashboardMonthKey;
  String? get dashboardMonthKey => _dashboardMonthKey;

  // Set the month to view on dashboard
  void setDashboardMonth(String? mKey) {
    _dashboardMonthKey = mKey;
    notifyListeners();
  }

  /// Initializes the Hive boxes and loads user preferences.
  Future<void> init() async {
    try {
      _expenseBox = await Hive.openBox<Expense>('expenses');
      _incomeBox = await Hive.openBox<MonthlyIncome>('incomes');
      await _loadCustomCategories();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Helper: Month key
  String monthKey(DateTime date) => DateFormat('yyyy-MM').format(date);
  String get currentMonthKey => monthKey(DateTime.now());

  // Get all Expenses for a specific month
  /// Retrieves all expenses for a given [mKey] (format: "YYYY-MM").
  /// Returns a list sorted by date descending.
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

  // Category breakdown for each month
  /// Calculates the total expense amount per category for a given month.
  Map<String, double> getCategoryBreakdown(String mKey) {
    final expenses = getExpenseForMonth(mKey);
    final Map<String, double> breakdown = {};
    for (final e in expenses) {
      breakdown[e.category] = (breakdown[e.category] ?? 0) + e.amount;
    }
    return breakdown;
  }

  // All Months that have data
  List<String> get availableMonths {
    final Set<String> months = {};
    for (final e in _expenseBox.values) {
      if (!e.isIncome) {
        months.add(monthKey(e.date));
      }
    }
    for (final i in _incomeBox.values) {
      months.add(i.monthKey);
    }
    final list = months.toList()..sort((a, b) => b.compareTo(a));
    return list;
  }

  // Add Expense
  /// Adds a new expense to the database.
  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    DateTime? date,
    String note = '',
  }) async {
    try {
      final expense = Expense(
        id: _uuid.v4(),
        title: title,
        amount: amount,
        category: category,
        date: date ?? DateTime.now(),
        note: note,
        isIncome: false,
      );
      await _expenseBox.put(expense.id, expense);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Edit Expense
  /// Updates an existing expense in the database.
  Future<void> editExpense({
    required String id,
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String note = '',
  }) async {
    try {
      final expense = _expenseBox.get(id);
      if (expense != null) {
        expense.title = title;
        expense.amount = amount;
        expense.category = category;
        expense.date = date;
        expense.note = note;
        await expense.save();
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Delete Expense
  Future<void> deleteExpense(String id) async {
    try {
      await _expenseBox.delete(id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // set monthly Income
  /// Sets or updates the monthly income for a specific [mKey].
  Future<void> setMonthlyIncome(double amount, {String? mKey}) async {
    try {
      final key = mKey ?? currentMonthKey;
      final existing = _incomeBox.values.where((i) => i.monthKey == key);
      if (existing.isNotEmpty) {
        final item = existing.first;
        item.amount = amount;
        await item.save();
      } else {
        final income = MonthlyIncome(monthKey: key, amount: amount);
        await _incomeBox.put(key, income);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Custom Categories — persisted in SharedPreferences
  List<String> _customCategories = [];
  List<String> get customCategories => List.unmodifiable(_customCategories);

  Future<void> _loadCustomCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _customCategories = prefs.getStringList('custom_categories') ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveCustomCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('custom_categories', _customCategories);
    } catch (e) {
      rethrow;
    }
  }

  // Add Custom Category
  /// Persists a new custom category name.
  Future<void> addCustomCategory(String name) async {
    if (!_customCategories.contains(name)) {
      _customCategories.add(name);
      await _saveCustomCategories();
      notifyListeners();
    }
  }

  Future<void> deleteCustomCategory(String name) async {
    _customCategories.remove(name);
    await _saveCustomCategories();
    notifyListeners();
  }

  Future<void> removeMonthlyIncome({String? mKey}) async {
    final key = mKey ?? currentMonthKey;
    final existing = _incomeBox.values.where((i) => i.monthKey == key).toList();
    for (final item in existing) {
      await item.delete();
    }
    notifyListeners();
  }
}

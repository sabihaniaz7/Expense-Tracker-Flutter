import 'package:expense_tracker/widgets/balance_card.dart';
import 'package:expense_tracker/widgets/expense_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../models/expense_model.dart';
import '../widgets/add_expense_sheet.dart';
import '../widgets/set_income_sheet.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final isDark = provider.isDarkMode;
    final textColor = isDark ? AppTheme.lightText : const Color(0xFF1A1A2E);
    final subColor = isDark ? AppTheme.subText : Colors.grey[500]!;
    final expenses = provider.currentMonthExpenses;
    final now = DateTime.now();
    final monthName = DateFormat('MMMM yyyy').format(now);
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : const Color(0xFFF5F5FA),
        body: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: true,
              backgroundColor: isDark
                  ? AppTheme.darkBg
                  : const Color(0xFFF5F5FA),
              toolbarHeight: 56,
              titleSpacing: 20,
              title: Text(
                monthName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              // Income Button
              actions: [
                GestureDetector(
                  onTap: () => _showSetIncome(context),
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 8,
                      top: 10,
                      bottom: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.safeGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.safeGreen.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: AppTheme.safeGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Set Income',
                          style: TextStyle(
                            color: AppTheme.safeGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Theme toggle
                IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                  ),
                  onPressed: () => provider.toggleTheme(),
                ),
              ],
            ),
            // Balance card
            SliverToBoxAdapter(child: const BalanceCard()),
            // Recent Expense Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      'Recent Expenses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '${expenses.length} transactions',
                      style: TextStyle(color: subColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            // Expense List
            expenses.isEmpty
                ? SliverToBoxAdapter(child: _EmptyState(isDark: isDark))
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final exp = expenses[index];
                      return Padding(
                        padding: const .symmetric(horizontal: 20),
                        child: ExpenseListItem(
                          expense: exp,
                          onEdit: () => _showEdit(context, exp),
                          onDelete: () => _confirmDelete(
                            context,
                            exp.id,
                            exp.title,
                            provider,
                          ),
                        ),
                      );
                    }, childCount: expenses.length),
                  ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddExpense(context),
          backgroundColor: AppTheme.neonPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 8,
          child: Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }

  void _showAddExpense(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseSheet(),
    );
  }

  void _showEdit(BuildContext context, Expense expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddExpenseSheet(editExpense: expense),
    );
  }

  void _showSetIncome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SetIncomeSheet(),
    );
  }

  void _confirmDelete(
    BuildContext context,
    String id,
    String title,
    ExpenseProvider provider,
  ) async {
    final isDark = provider.isDarkMode;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Delete Expense?",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: isDark ? AppTheme.lightText : const Color(0xFF1A1A2E),
          ),
        ),
        content: Text(
          '"$title" will be permanently removed.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppTheme.subText : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: isDark ? AppTheme.subText : Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "Delete",
              style: TextStyle(
                color: AppTheme.dangerRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      provider.deleteExpense(id);
    }
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 50),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 80,
            color: isDark ? Colors.white24 : Colors.grey[300],
          ),
          const SizedBox(height: 6),
          Text(
            "No Expenses Yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppTheme.lightText : const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Tap the button below to add your first expense',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppTheme.subText : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

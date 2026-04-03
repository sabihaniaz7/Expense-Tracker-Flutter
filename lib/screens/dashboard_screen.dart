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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _viewingMonthKey; // null means 'current month'
  String _activeMonthKey(ExpenseProvider provider) =>
      _viewingMonthKey ?? provider.currentMonthKey;

  bool get _isBrowsingPast => _viewingMonthKey != null;
  void _resetToCurrentMonth() => setState(() => _viewingMonthKey = null);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final isDark = provider.isDarkMode;
    final textColor = isDark ? AppTheme.lightText : const Color(0xFF1A1A2E);
    final subColor = isDark ? AppTheme.subText : Colors.grey[500]!;
    final mKey = _activeMonthKey(provider);
    final expenses = provider.getExpenseForMonth(mKey);
    final date = DateTime.parse('$mKey-01');
    final fullMonth = DateFormat('MMMM').format(date);
    final monthDisplay = fullMonth.length > 5
        ? DateFormat('MMM').format(date)
        : fullMonth;
    final year = DateFormat('yyyy').format(date);
    final monthLabel = '$monthDisplay $year';
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
              title: GestureDetector(
                onTap: () => _pickMonth(context, provider),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : Colors.black.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        monthLabel,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(width: 2),
                      // DropDown arrow
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: isDark ? Colors.white54 : Colors.black38,
                      ),
                    ],
                  ),
                ),
              ),
              // Income Button
              actions: [
                GestureDetector(
                  onTap: () => _showSetIncome(context, mKey),
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 0,
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
                        Text(
                          'Set Income',
                          style: TextStyle(
                            color: AppTheme.safeGreen,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
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
            // ── "Viewing past month" banner ────────────────────────────────────
            if (_isBrowsingPast)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      // Icon(Icons.history_rounded, size: 14, color: subColor),
                      // const SizedBox(width: 6),
                      Text(
                        'Browsing past month',
                        style: TextStyle(fontSize: 12, color: subColor),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _resetToCurrentMonth,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkCard : Colors.white70,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.grey.withValues(alpha: 0.1),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'Back to current',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Balance card
            SliverToBoxAdapter(child: BalanceCard(monthKey: mKey)),
            // Recent Expense Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Expenses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '${expenses.length} transactions',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ExpenseListItem(
                          expense: exp,
                          onEdit: () => _showEdit(context, exp),
                          onDelete: () => provider.deleteExpense(exp.id),
                        ),
                      );
                    }, childCount: expenses.length),
                  ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddExpense(context, mKey),
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

  void _showAddExpense(BuildContext context, String mKey) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddExpenseSheet(defaultMonthKey: mKey),
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

  void _showSetIncome(BuildContext context, String mKey) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SetIncomeSheet(monthKey: mKey),
    );
  }

  Future<void> _pickMonth(
    BuildContext context,
    ExpenseProvider provider,
  ) async {
    final isDark = provider.isDarkMode;
    final bg = isDark ? AppTheme.darkCard : Colors.white;
    final textColor = isDark ? AppTheme.lightText : const Color(0xFF1A1A2E);
    final subColor = isDark ? AppTheme.subText : Colors.grey[500]!;

    // Build list: current month first, then all months that have data
    final Set<String> monthSet = {provider.currentMonthKey};
    monthSet.addAll(provider.availableMonths);
    final months = monthSet.toList()..sort((a, b) => b.compareTo(a));
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            //
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Month',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Browse any month\'s balance & expenses',
              style: TextStyle(fontSize: 13, color: subColor),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: months.length,
                itemBuilder: (ctx, i) {
                  final mKey = months[i];
                  final isCurrentMonth = mKey == provider.currentMonthKey;
                  final isSelected = mKey == _activeMonthKey(provider);
                  final date = DateTime.parse('$mKey-01');
                  final label = DateFormat('MMMM yyyy').format(date);
                  final totalExp = provider.getTotalExpensesForMonth(mKey);
                  final income = provider.getIncomeForMonth(mKey);
                  final fmt = NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 0,
                  );

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _viewingMonthKey = isCurrentMonth ? null : mKey;
                      });
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [
                                  AppTheme.neonPurple,
                                  AppTheme.neonPink,
                                ],
                              )
                            : null,
                        color: isSelected
                            ? null
                            : (isDark
                                  ? AppTheme.darkSurface
                                  : const Color(0xFFF5F5FA)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      label,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: isSelected
                                            ? Colors.white
                                            : textColor,
                                      ),
                                    ),
                                    if (isCurrentMonth) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.white.withValues(
                                                  alpha: 0.25,
                                                )
                                              : AppTheme.safeGreen.withValues(
                                                  alpha: 0.15,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'Current',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white
                                                : AppTheme.safeGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (totalExp > 0 || income > 0)
                                  Text(
                                    income > 0
                                        ? '${fmt.format(totalExp)} spent · ${fmt.format(income)} income'
                                        : '${fmt.format(totalExp)} spent',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white.withValues(alpha: 0.75)
                                          : subColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
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
              fontWeight: FontWeight.w500,
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

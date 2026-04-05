import 'package:expense_tracker/widgets/common/app_sheet.dart';
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
  String _activeMonthKey(ExpenseProvider provider) =>
      provider.dashboardMonthKey ?? provider.currentMonthKey;

  bool _isBrowsingPast(ExpenseProvider provider) =>
      provider.dashboardMonthKey != null;

  void _resetToCurrentMonth(ExpenseProvider provider) =>
      setState(() => provider.setDashboardMonth(null));

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final isDark = provider.isDarkMode;
    final textColor = isDark ? AppTheme.lightText : AppTheme.lightPrimaryText;
    final subColor = isDark ? AppTheme.subText : AppTheme.lightSubText;
    final mKey = _activeMonthKey(provider);
    final isBrowsingPast = _isBrowsingPast(provider);
    final expenses = provider.getExpenseForMonth(mKey);
    final date = DateTime.parse('$mKey-01');
    final fullMonth = DateFormat('MMMM').format(date);
    final monthDisplay =
        fullMonth.length > 5 ? DateFormat('MMM').format(date) : fullMonth;
    final year = DateFormat('yyyy').format(date);
    final monthLabel = '$monthDisplay $year';
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        body: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: true,
              backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
              toolbarHeight: AppTheme.sp56,
              titleSpacing: AppTheme.sp20,
              title: GestureDetector(
                onTap: () => _pickMonth(context, provider),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.sp10,
                    vertical: AppTheme.sp6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.neonPurple,
                    borderRadius: BorderRadius.circular(AppTheme.rad20),
                    border: Border.all(
                      color: isDark
                          ? AppTheme.lightSurface.withValues(alpha: 0.12)
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
                          fontSize: AppTheme.fs20,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(width: AppTheme.sp4 / 2),
                      // DropDown arrow
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        size: AppTheme.sp20,
                        color: isDark
                            ? AppTheme.lightSurface.withValues(alpha: 0.54)
                            : Colors.black.withValues(alpha: 0.38),
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
                      top: AppTheme.sp10,
                      bottom: AppTheme.sp10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.sp12,
                      vertical: AppTheme.sp6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.safeGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppTheme.rad20),
                      border: Border.all(
                        color: AppTheme.safeGreen.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: AppTheme.safeGreen,
                          size: AppTheme.sp16,
                        ),
                        Text(
                          'Set Income',
                          style: TextStyle(
                            color: AppTheme.safeGreen,
                            fontWeight: FontWeight.w400,
                            fontSize: AppTheme.fs13,
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
                    color: isDark
                        ? AppTheme.lightSurface.withValues(alpha: 0.6)
                        : AppTheme.lightSubText,
                  ),
                  onPressed: () => provider.toggleTheme(),
                ),
              ],
            ),
            // ── "Viewing past month" banner ────────────────────────────────────
            if (isBrowsingPast)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.sp20,
                    vertical: AppTheme.sp4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Browsing past month',
                        style: TextStyle(
                          fontSize: AppTheme.fs12,
                          color: subColor,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _resetToCurrentMonth(provider),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.sp10,
                            vertical: AppTheme.sp4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.darkCard
                                : AppTheme.lightSurface.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(AppTheme.rad20),
                            border: Border.all(
                              color: isDark
                                  ? AppTheme.lightSurface.withValues(
                                    alpha: 0.05,
                                  )
                                  : AppTheme.lightSubText.withValues(
                                    alpha: 0.1,
                                  ),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'Back to current',
                                style: TextStyle(
                                  fontSize: AppTheme.fs11,
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
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.sp20,
                  AppTheme.sp6,
                  AppTheme.sp20,
                  AppTheme.sp10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Expenses',
                      style: TextStyle(
                        fontSize: AppTheme.fs18,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '${expenses.length} transactions',
                      style: TextStyle(
                        color: subColor,
                        fontSize: AppTheme.fs13,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.sp20,
                      ),
                      child: ExpenseListItem(
                        expense: exp,
                        onEdit: () => _showEdit(context, exp),
                        onDelete: () => provider.deleteExpense(exp.id),
                      ),
                    );
                  }, childCount: expenses.length),
                ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.sp60 + AppTheme.sp40),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddExpense(context, mKey),
          backgroundColor: AppTheme.neonPurple,
          foregroundColor: AppTheme.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.rad18),
          ),
          elevation: 8,
          child: const Icon(Icons.add_rounded, size: AppTheme.sp28),
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
      builder: (_) => AppSheet(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.sp20,
          AppTheme.sp16,
          AppTheme.sp20,
          AppTheme.sp32,
        ),
        children: [
          Text(
            'Select Month',
            style: TextStyle(
              fontSize: AppTheme.fs20,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: AppTheme.sp4),
          Text(
            'Browse any month\'s balance & expenses',
            style: TextStyle(fontSize: AppTheme.fs13, color: subColor),
          ),
          const SizedBox(height: AppTheme.sp16),
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
                    provider.setDashboardMonth(isCurrentMonth ? null : mKey);
                    Navigator.pop(context);
                  },
                  child: AnimatedContainer(
                    duration: AppTheme.durFast,
                    margin: const EdgeInsets.only(bottom: AppTheme.sp8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.sp16,
                      vertical: AppTheme.sp13, // need sp13 in AppTheme
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
                                : AppTheme.lightBg),
                      borderRadius: BorderRadius.circular(AppTheme.rad14),
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
                                      fontSize: AppTheme.fs15,
                                      color: isSelected
                                          ? AppTheme.lightSurface
                                          : textColor,
                                    ),
                                  ),
                                  if (isCurrentMonth) ...[
                                    const SizedBox(width: AppTheme.sp8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: AppTheme.rad2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppTheme.lightSurface.withValues(
                                                alpha: 0.25,
                                              )
                                            : AppTheme.safeGreen.withValues(
                                                alpha: 0.15,
                                              ),
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.rad8,
                                        ),
                                      ),
                                      child: Text(
                                        'Current',
                                        style: TextStyle(
                                          fontSize: AppTheme.fs10,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? AppTheme.lightSurface
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
                                    fontSize: AppTheme.fs12,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? AppTheme.lightSurface.withValues(
                                            alpha: 0.75,
                                          )
                                        : subColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_rounded,
                            color: AppTheme.lightSurface,
                            size: AppTheme.sp18, // need sp18 in AppTheme
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
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.sp50),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: AppTheme.sp80,
            color: isDark
                ? AppTheme.lightSurface.withValues(alpha: 0.24)
                : AppTheme.lightSubText.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppTheme.sp6),
          Text(
            "No Expenses Yet",
            style: TextStyle(
              fontSize: AppTheme.fs18,
              fontWeight: FontWeight.w500,
              color: isDark ? AppTheme.lightText : AppTheme.lightPrimaryText,
            ),
          ),
          const SizedBox(height: AppTheme.rad2),
          Text(
            'Tap the button below to add your first expense',
            style: TextStyle(
              fontSize: AppTheme.fs14,
              color: isDark
                  ? AppTheme.subText
                  : AppTheme.lightSubText.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

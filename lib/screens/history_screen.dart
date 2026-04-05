import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/add_expense_sheet.dart';
import '../models/expense_model.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final Set<String> _expandedMonths = {};

  @override
  void initState() {
    super.initState();
    // Expand current month by default
    final now = DateTime.now();
    _expandedMonths.add('${now.year}-${now.month.toString().padLeft(2, '0')}');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final isDark = provider.isDarkMode;
    final textColor = isDark ? AppTheme.lightText : AppTheme.lightPrimaryText;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightSurface;
    final subColor = isDark ? AppTheme.subText : AppTheme.lightSubText;

    var allExpenses = provider.allExpenses;
    // Search by name or category or month name/year
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      allExpenses = allExpenses.where((e) {
        final monthName = DateFormat('MMMM').format(e.date).toLowerCase();
        final monthYear = DateFormat('MMMM yyyy').format(e.date).toLowerCase();
        return e.title.toLowerCase().contains(q) ||
            e.category.toLowerCase().contains(q) ||
            monthName.contains(q) ||
            monthYear.contains(q);
      }).toList();
    }
    // Group By month
    final Map<String, List<Expense>> grouped = {};
    for (final e in allExpenses) {
      final key = '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(e);
    }
    // Sort months descending
    final sortedMonths = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
              title: Text(
                'History',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: AppTheme.fs24,
                  color: textColor,
                ),
              ),
            ),
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.sp20,
                  0,
                  AppTheme.sp20,
                  AppTheme.sp16,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: TextStyle(color: textColor, fontSize: AppTheme.fs14),
                  decoration: InputDecoration(
                    hintText: 'Search by name, category or month',
                    hintStyle: TextStyle(
                      color: subColor,
                      fontSize: AppTheme.fs13,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: subColor,
                      size: AppTheme.sp20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              color: subColor,
                              size: AppTheme.sp18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.rad14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.sp16,
                      vertical: AppTheme.sp12,
                    ),
                  ),
                ),
              ),
            ),
            // Expense Groups
            sortedMonths.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.sp60,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.doc_text_search,
                            size: AppTheme.sp56,
                            color: subColor,
                          ),
                          const SizedBox(height: AppTheme.sp16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No results found'
                                : 'No expenses yet',
                            style: TextStyle(
                              fontSize: AppTheme.fs18,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      final month = sortedMonths[i];
                      final expenses = grouped[month]!;
                      final total = expenses.fold(0.0, (s, e) => s + e.amount);
                      final date = DateTime.parse('$month-01');
                      final monthName = DateFormat('MMMM yyyy').format(date);
                      final isExpanded = _expandedMonths.contains(month);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.sp20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Month header
                            GestureDetector(
                              onTap: () => setState(() {
                                if (isExpanded) {
                                  _expandedMonths.remove(month);
                                } else {
                                  _expandedMonths.add(month);
                                }
                              }),
                              child: Container(
                                margin: const EdgeInsets.only(
                                  bottom: AppTheme.sp12,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.sp16,
                                  vertical: AppTheme.sp12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: isDark
                                        ? [
                                            AppTheme.neonPurple.withValues(
                                              alpha: 0.1,
                                            ),
                                            AppTheme.neonPink.withValues(
                                              alpha: 0.1,
                                            ),
                                          ]
                                        : [
                                            AppTheme.lightAccent,
                                            AppTheme.lightAccentSecondary,
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.rad16,
                                  ),
                                  border: Border.all(
                                    color: isDark
                                        ? AppTheme.neonPurple.withValues(
                                            alpha: 0.18,
                                          )
                                        : AppTheme.neonPurple.withValues(
                                            alpha: 0.15,
                                          ),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: AppTheme.sp36,
                                      height: AppTheme.sp36,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppTheme.neonPurple.withValues(
                                              alpha: 0.3,
                                            ),
                                            AppTheme.neonPink.withValues(
                                              alpha: 0.3,
                                            ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.rad10,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.calendar_month_rounded,
                                          color: isDark
                                              ? AppTheme.lightSurface
                                                    .withValues(alpha: 0.7)
                                              : Colors.black54,
                                          size: AppTheme.sp18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.sp12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            monthName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: textColor,
                                              fontSize: AppTheme.fs17,
                                            ),
                                          ),
                                          Text(
                                            '${expenses.length} transactions',
                                            style: TextStyle(
                                              fontSize: AppTheme.fs12,
                                              color: subColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '- ${fmt.format(total)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.dangerRed,
                                        fontSize: AppTheme.fs15,
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.sp8),
                                    AnimatedRotation(
                                      turns: isExpanded ? 0.5 : 0,
                                      duration: AppTheme.durStandard,
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: subColor,
                                        size: AppTheme.sp18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Expense items (when expanded)
                            if (isExpanded)
                              ...expenses.map(
                                (e) => ExpenseListItem(
                                  expense: e,
                                  onEdit: () => _showEdit(context, e),
                                  onDelete: () => provider.deleteExpense(e.id),
                                ),
                              ),

                            const SizedBox(height: AppTheme.sp8),
                          ],
                        ),
                      );
                    }, childCount: sortedMonths.length),
                  ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.sp60 + AppTheme.sp40),
            ),
          ],
        ),
      ),
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
}

import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String? _selectedMonth;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final months = context.read<ExpenseProvider>().availableMonths;
      if (months.isNotEmpty) setState(() => _selectedMonth = months.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final isDark = provider.isDarkMode;
    final textColor = isDark ? AppTheme.lightText : const Color(0xFF1A1A2E);
    final subColor = isDark ? AppTheme.subText : Colors.grey[500]!;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    final months = provider.availableMonths;
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    if (_selectedMonth == null ||
        (_selectedMonth != null && !months.contains(_selectedMonth))) {
      _selectedMonth = months.isNotEmpty ? months.first : null;
      _touchedIndex = -1;
    }
    final breakdown = _selectedMonth != null
        ? provider.getCategoryBreakdown(_selectedMonth!)
        : <String, double>{};

    final total = breakdown.values.fold(0.0, (s, v) => s + v);
    final income = _selectedMonth != null
        ? provider.getIncomeForMonth(_selectedMonth!)
        : 0.0;
    final sortedBreakdown = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // final highestCat = sortedBreakdown.isNotEmpty
    //     ? sortedBreakdown.first
    //     : null;

    // Get previous month comparison
    double previousTotal = 0;
    if (_selectedMonth != null && months.length > 1) {
      final idx = months.indexOf(_selectedMonth!);
      if (idx < months.length - 1) {
        previousTotal = provider.getTotalExpensesForMonth(months[idx + 1]);
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : const Color(0xFFF5F5FA),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: isDark
                  ? AppTheme.darkBg
                  : const Color(0xFFF5F5FA),
              title: Text(
                'Statistics',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ),
            // Month Picker
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.builder(
                  padding: const .symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: months.length,
                  itemBuilder: (context, i) {
                    final mKey = months[i];
                    final isSelected = _selectedMonth == mKey;
                    final date = DateTime.parse('$mKey-01');
                    final label = DateFormat('MMM yyyy').format(date);

                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedMonth = mKey;
                        _touchedIndex = -1;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const .only(right: 8),
                        padding: const .symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.neonPurple
                              : (isDark ? AppTheme.darkCard : Colors.white),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.neonPurple
                                : Colors.transparent,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : subColor,
                              fontWeight: .w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_selectedMonth == null || breakdown.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
                      const Text('📊', style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 16),
                      Text(
                        'No data for this month',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // Pie Chart card
              SliverToBoxAdapter(
                child: Container(
                  margin: const .all(20),
                  padding: const .all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            DateFormat(
                              'MMMM yyyy',
                            ).format(DateTime.parse('$_selectedMonth-01')),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: .w500,
                              color: textColor,
                            ),
                          ),
                          Text(
                            '- ${fmt.format(total)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.dangerRed,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            sections: sortedBreakdown.asMap().entries.map((
                              entry,
                            ) {
                              final idx = entry.key;
                              final cat = entry.value.key;
                              final val = entry.value.value;
                              final color = AppCategories.getColor(cat);
                              final isTouched = idx == _touchedIndex;
                              return PieChartSectionData(
                                color: color,
                                value: val,
                                title: isTouched
                                    ? '${(val / total * 100).toStringAsFixed(1)}%'
                                    : '',
                                radius: isTouched ? 90 : 75,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              );
                            }).toList(),
                            pieTouchData: PieTouchData(
                              touchCallback: (event, pieTouchResponse) {
                                setState(() {
                                  if (pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    _touchedIndex = -1;
                                  } else {
                                    _touchedIndex = pieTouchResponse
                                        .touchedSection!
                                        .touchedSectionIndex;
                                  }
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            centerSpaceRadius: 50,
                            sectionsSpace: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Summary stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const .symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryChip(
                          label: 'Income',
                          value: fmt.format(income),
                          color: AppTheme.safeGreen,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryChip(
                          label: 'vs Last Month',
                          value: previousTotal == 0
                              ? 'N/A'
                              : total > previousTotal
                              ? '+${fmt.format(total - previousTotal)}'
                              : '-${fmt.format(previousTotal - total)}',
                          color: total > previousTotal
                              ? AppTheme.dangerRed
                              : AppTheme.safeGreen,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Highest Category
              // if (highestCat != null)
              //   SliverToBoxAdapter(
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              //       child: Container(
              //         padding: const EdgeInsets.all(16),
              //         decoration: BoxDecoration(
              //           color: AppCategories.getColor(
              //             highestCat.key,
              //           ).withValues(alpha: 0.1),
              //           borderRadius: BorderRadius.circular(16),
              //           border: Border.all(
              //             color: AppCategories.getColor(
              //               highestCat.key,
              //             ).withValues(alpha: 0.3),
              //           ),
              //         ),
              //         child: Row(
              //           children: [
              //             Text(
              //               AppCategories.getEmoji(highestCat.key),
              //               style: const TextStyle(fontSize: 24),
              //             ),
              //             const SizedBox(width: 12),
              //             Column(
              //               crossAxisAlignment: .start,
              //               children: [
              //                 Text(
              //                   'Highest Spending',
              //                   style: TextStyle(
              //                     fontSize: 13,
              //                     color: subColor,
              //                     fontWeight: .w500,
              //                   ),
              //                 ),
              //                 Text(
              //                   highestCat.key,
              //                   style: TextStyle(
              //                     fontSize: 15,
              //                     fontWeight: FontWeight.w600,
              //                     color: AppCategories.getColor(highestCat.key),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             const Spacer(),
              //             Text(
              //               fmt.format(highestCat.value),
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w500,
              //                 color: AppCategories.getColor(highestCat.key),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // Category breakdown list
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                  child: Text(
                    'Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  final entry = sortedBreakdown[i];
                  final color = AppCategories.getColor(entry.key);
                  final emoji = AppCategories.getEmoji(entry.key);
                  final pct = total > 0 ? entry.value / total : 0;
                  final isTouched = i == _touchedIndex;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _touchedIndex = isTouched ? -1 : i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isTouched
                            ? color.withValues(alpha: 0.1)
                            : cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isTouched
                              ? color.withValues(alpha: 0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text(emoji)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      fmt.format(entry.value),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct.toDouble(),
                                    backgroundColor: color.withValues(
                                      alpha: 0.1,
                                    ),
                                    valueColor: AlwaysStoppedAnimation(color),
                                    minHeight: 5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${(pct * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: subColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: sortedBreakdown.length),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: color.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
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
    final textColor = isDark ? AppTheme.lightText : AppTheme.lightPrimaryText;
    final subColor = isDark ? AppTheme.subText : AppTheme.lightSubText;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightSurface;
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
    final remaining = (income - total).clamp(0.0, double.infinity);
    final sortedBreakdown = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // final highestCat = sortedBreakdown.isNotEmpty
    //     ? sortedBreakdown.first
    //     : null;

    // Pie sections: expense categories + income-remaining slice
    // Centre label changes based on touched slice
    String centerTop = fmt.format(total);
    String centerBottom = 'spent';
    if (_touchedIndex >= 0 && _touchedIndex < sortedBreakdown.length) {
      final cat = sortedBreakdown[_touchedIndex];
      centerTop = fmt.format(cat.value);
      centerBottom = cat.key;
    } else if (_touchedIndex == sortedBreakdown.length && income > 0) {
      centerTop = fmt.format(remaining);
      centerBottom = 'remaining';
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
              title: Text(
                'Statistics',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: AppTheme.fs24,
                ),
              ),
            ),
            // Month Picker
            SliverToBoxAdapter(
              child: SizedBox(
                height: AppTheme.sp44,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.sp20,
                  ),
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
                        duration: AppTheme.durStandard,
                        margin: const EdgeInsets.only(right: AppTheme.sp8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.sp16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppTheme.rad22),
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
                                    ? AppTheme.darkCard
                                    : AppTheme.lightSurface),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppTheme.neonPurple.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: AppTheme.rad10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),

                        child: Center(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppTheme.lightSurface
                                  : subColor,
                              fontWeight: FontWeight.w500,
                              fontSize: AppTheme.fs13,
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
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.sp60),
                  child: Column(
                    children: [
                      const SizedBox(height: AppTheme.sp60),
                      Icon(CupertinoIcons.doc_chart, size: 80, color: subColor),
                      const SizedBox(height: AppTheme.sp16),
                      Center(
                        child: Text(
                          'No data available.\nAdd expenses to see statistics.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppTheme.fs18,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
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
                  margin: const EdgeInsets.fromLTRB(
                    AppTheme.sp20,
                    AppTheme.sp20,
                    AppTheme.sp20,
                    0,
                  ),
                  padding: const EdgeInsets.all(AppTheme.sp24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(AppTheme.rad24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat(
                              'MMMM yyyy',
                            ).format(DateTime.parse('$_selectedMonth-01')),
                            style: TextStyle(
                              fontSize: AppTheme.fs20,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                income > 0 ? '+ ${fmt.format(income)}' : '',
                                style: TextStyle(
                                  fontSize: AppTheme.fs16,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.safeGreen,
                                ),
                              ),
                              Text(
                                '- ${fmt.format(total)}',
                                style: TextStyle(
                                  fontSize: AppTheme.fs16,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.dangerRed,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.sp20),
                      SizedBox(
                        height: AppTheme.sp220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
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
                                        ? '${(val / (income > 0 ? income : total) * 100).toStringAsFixed(1)}%'
                                        : '',
                                    radius: isTouched ? 95 : 80,
                                    titlePositionPercentageOffset: 0.55,
                                    titleStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AppTheme.fs14,
                                    ),
                                  );
                                }).toList(),
                                pieTouchData: PieTouchData(
                                  touchCallback: (event, pieTouchResponse) {
                                    setState(() {
                                      if (pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
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
                                sectionsSpace: 2,
                              ),
                            ),
                            // Centre label
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  centerTop,
                                  style: TextStyle(
                                    fontSize: AppTheme.fs18,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  centerBottom,
                                  style: TextStyle(
                                    fontSize: AppTheme.fs12,
                                    fontWeight: FontWeight.w500,
                                    color: subColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
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
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                   'Highest Spending',
              //                   style: TextStyle(
              //                     fontSize: 13,
              //                     color: subColor,
              //                     fontWeight: FontWeight.w500,
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
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.sp20,
                    AppTheme.sp12,
                    AppTheme.sp20,
                    AppTheme.sp4,
                  ),
                  child: Text(
                    'Breakdown',
                    style: TextStyle(
                      fontSize: AppTheme.fs16,
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
                      margin: const EdgeInsets.fromLTRB(
                        AppTheme.sp20,
                        0,
                        AppTheme.sp20,
                        AppTheme.sp10,
                      ),
                      padding: const EdgeInsets.all(AppTheme.sp16),
                      decoration: BoxDecoration(
                        color: isTouched
                            ? color.withValues(alpha: 0.1)
                            : cardColor,
                        borderRadius: BorderRadius.circular(AppTheme.rad16),
                        border: Border.all(
                          color: isTouched
                              ? color.withValues(alpha: 0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: AppTheme.sp40,
                            height: AppTheme.sp40,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(
                                AppTheme.rad10,
                              ),
                            ),
                            child: Center(child: Text(emoji)),
                          ),
                          const SizedBox(width: AppTheme.sp12),
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
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                        fontSize: AppTheme.fs15,
                                      ),
                                    ),
                                    Text(
                                      fmt.format(entry.value),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                        fontSize: AppTheme.fs15,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppTheme.sp6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.rad4,
                                  ),
                                  child: LinearProgressIndicator(
                                    value: pct.toDouble(),
                                    backgroundColor: color.withValues(
                                      alpha: 0.1,
                                    ),
                                    valueColor: AlwaysStoppedAnimation(color),
                                    minHeight: 5,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.sp4),
                                Text(
                                  '${(pct * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: AppTheme.fs11,
                                    color: subColor,
                                    fontWeight: FontWeight.w500,
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
              const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.sp90 + AppTheme.sp10),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

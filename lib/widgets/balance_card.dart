import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'package:intl/intl.dart';

/// Dashboard component showing current balance, income vs expenses, and budget progress.
class BalanceCard extends StatelessWidget {
  /// The month this card displays. Defaults to current month if null.
  final String? monthKey;
  const BalanceCard({super.key, this.monthKey});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final mKey = monthKey ?? provider.currentMonthKey;
    final income = provider.getIncomeForMonth(mKey);
    final expenses = provider.getTotalExpensesForMonth(mKey);
    final remaining = income - expenses;
    final usedPct = income > 0 ? (expenses / income) * 100 : 0.0;
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    // Warning level
    int warningLevel = 0;
    if (usedPct >= 100) {
      warningLevel = 3;
    } else if (usedPct >= 90) {
      warningLevel = 2;
    } else if (usedPct >= 70) {
      warningLevel = 1;
    }

    //Card gradient colors based on warning level
    List<Color> gradientColors;
    Color glowColor;
    switch (warningLevel) {
      case 1:
        gradientColors = [const Color(0xFF8B6914), const Color(0xFFFFD166)];
        glowColor = AppTheme.warningYellow.withValues(alpha: 0.5);
        break;
      case 2:
        gradientColors = [const Color(0xFF8B4513), const Color(0xFFFF9F43)];
        glowColor = AppTheme.warningOrange.withValues(alpha: 0.5);
        break;
      case 3:
        gradientColors = [const Color(0xFF8B1414), const Color(0xFFFF6B6B)];
        glowColor = AppTheme.dangerRed.withValues(alpha: 0.5);
        break;
      default:
        gradientColors = [AppTheme.neonPurple, AppTheme.neonPink];
        glowColor = AppTheme.neonPurple.withValues(alpha: 0.4);
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 30,
            spreadRadius: warningLevel > 0 ? 4 : 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Balance',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Remaining Amount
            Text(
              remaining < 0
                  ? '-${fmt.format(remaining.abs())}'
                  : fmt.format(remaining),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 20),
            // Progress Bar
            _ProgressBar(usedPct: usedPct, warningLevel: warningLevel),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${usedPct.toStringAsFixed(0)}% used',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'of ${fmt.format(income)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Income / Expense Row
            Row(
              children: [
                Expanded(
                  child: _StatChip(
                    label: 'Income',
                    amount: fmt.format(income),
                    icon: '↑',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatChip(
                    label: 'Expenses',
                    amount: fmt.format(expenses),
                    icon: '↓',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Goal Section
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String amount;
  final String icon;
  final Color color;

  const _StatChip({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Container(
          //   width: 30,
          //   height: 30,
          //   decoration: BoxDecoration(
          //     color: Colors.white.withValues(alpha: 0.15),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Center(
          //     child: Text(
          //       icon,
          //       style: TextStyle(
          //         color: color,
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 1),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    amount,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double usedPct;
  final int warningLevel;

  const _ProgressBar({required this.usedPct, required this.warningLevel});

  @override
  Widget build(BuildContext context) {
    final pct = (usedPct / 100).clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 6,
        color: Colors.white.withValues(alpha: 0.2),
        child: FractionallySizedBox(
          widthFactor: pct,
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

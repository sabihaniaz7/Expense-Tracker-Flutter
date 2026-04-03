import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class SetIncomeSheet extends StatefulWidget {
  /// The month key (e.g. "2026-03") this sheet sets income for.
  /// Defaults to current month if null
  final String? monthKey;
  const SetIncomeSheet({super.key, this.monthKey});

  @override
  State<SetIncomeSheet> createState() => _SetIncomeSheetState();
}

class _SetIncomeSheetState extends State<SetIncomeSheet> {
  final _ctrl = TextEditingController();
  String get _mKey =>
      widget.monthKey ?? context.read<ExpenseProvider>().currentMonthKey;

  String get _monthLabel {
    final date = DateTime.parse('$_mKey-01');
    return DateFormat('MMMM yyyy').format(date);
  }

  @override
  void initState() {
    super.initState();
    final income = context.read<ExpenseProvider>().getIncomeForMonth(_mKey);
    if (income > 0) _ctrl.text = income.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ExpenseProvider>().isDarkMode;
    final bg = isDark ? AppTheme.darkCard : Colors.white;
    final textColor = isDark ? AppTheme.lightText : const Color(0xFF1A1A2E);
    return Container(
      padding: .only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
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
          const SizedBox(height: 24),
          Text(
            'Set Monthly Income',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          // Show which month is being edited — key detail
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.neonPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _monthLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            'Used to calculate remaining balance for this month.',
            style: TextStyle(
              fontSize: 13,
              color: textColor.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _ctrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            decoration: InputDecoration(
              prefixText: '\$  ',
              prefixStyle: TextStyle(
                color: AppTheme.neonPurple,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              hintText: '0',
              hintStyle: TextStyle(
                color: textColor.withValues(alpha: 0.2),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: isDark
                  ? AppTheme.darkSurface
                  : const Color(0xFFF5F5FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_ctrl.text) ?? 0;
                if (amount > 0) {
                  context.read<ExpenseProvider>().setMonthlyIncome(amount);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.neonPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save Income',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

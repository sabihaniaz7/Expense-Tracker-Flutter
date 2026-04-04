import 'package:expense_tracker/widgets/common/app_button.dart';
import 'package:expense_tracker/widgets/common/app_input_field.dart';
import 'package:expense_tracker/widgets/common/app_sheet.dart';
import 'package:expense_tracker/widgets/common/month_pill.dart';
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
    final textColor = isDark ? AppTheme.lightText : const Color(0xFF1A1A2E);

    return AppSheet(
      children: [
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
        MonthPill(label: _monthLabel),
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
        AppInputField(
          controller: _ctrl,
          hint: '0',
          isDark: isDark,
          textColor: textColor,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          fontSize: 28,
          fontWeight: FontWeight.bold,
          prefixText: '\$  ',
        ),
        const SizedBox(height: 20),
        AppButton(
          text: 'Save Income',
          onPressed: () {
            final amount = double.tryParse(_ctrl.text) ?? 0;
            if (amount > 0) {
              context.read<ExpenseProvider>().setMonthlyIncome(amount);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}

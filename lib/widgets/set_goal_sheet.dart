import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:expense_tracker/widgets/common/app_button.dart';
import 'package:expense_tracker/widgets/common/app_input_field.dart';
import 'package:expense_tracker/widgets/common/app_sheet.dart';
import 'package:expense_tracker/widgets/common/month_pill.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SetGoalSheet extends StatefulWidget {
  final String monthKey;
  final double? existingGoal;
  const SetGoalSheet({super.key, required this.monthKey, this.existingGoal});

  @override
  State<SetGoalSheet> createState() => _SetGoalSheetState();
}

class _SetGoalSheetState extends State<SetGoalSheet> {
  final _ctrl = TextEditingController();

  String get _monthLabel {
    final date = DateTime.parse('${widget.monthKey}-01');
    return DateFormat('MMMM yyyy').format(date);
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingGoal != null) {
      _ctrl.text = widget.existingGoal!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final isDark = provider.isDarkMode;
    final textColor = isDark ? AppTheme.lightText : const Color(0xFF1A1A2E);
    final subColor = isDark ? AppTheme.subText : Colors.grey[500]!;

    return AppSheet(
      children: [
        // Title Row
        Text(
          widget.existingGoal != null ? 'Edit Budget Goal' : 'Set Budget Goal',
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        // Month pill
        MonthPill(label: _monthLabel),
        const SizedBox(height: 8),
        Text(
          'Set a spending limit. Will track how close you are.',
          style: TextStyle(fontSize: 13, color: subColor),
        ),
        const SizedBox(height: 24),
        // Amount field
        AppInputField(
          controller: _ctrl,
          hint: '0',
          isDark: isDark,
          textColor: textColor,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          fontSize: 32,
          prefixText: '\$  ',
        ),
        const SizedBox(height: 20),
        // Save button
        AppButton(
          text: 'Save Goal',
          onPressed: () async {
            final amount = double.tryParse(_ctrl.text) ?? 0;
            if (amount > 0) {
              await provider.setGoalForMonth(amount, widget.monthKey);
              if (context.mounted) Navigator.pop(context);
            }
          },
        ),
        // Remove goal link — only if editing existing
        if (widget.existingGoal != null) ...[
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onTap: () async {
                await provider.removeGoalForMonth(widget.monthKey);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(
                'Remove goal',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.dangerRed.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.dangerRed.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

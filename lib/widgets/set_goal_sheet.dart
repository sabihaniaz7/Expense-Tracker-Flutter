import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/theme/app_theme.dart';
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
    final bg = isDark ? AppTheme.darkCard : Colors.white;
    final textColor = isDark ? AppTheme.lightText : const Color(0xFF1A1A2E);
    final subColor = isDark ? AppTheme.subText : Colors.grey[500]!;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          // Handle
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
          // Title Row
          Row(
            children: [
              Text(
                widget.existingGoal != null
                    ? 'Edit Budget Goal'
                    : 'Set Budget Goal',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Month pill + description
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Set a spending limit. Will track how close you are.',
            style: TextStyle(fontSize: 13, color: subColor),
          ),
          const SizedBox(height: 24),
          // Amount field
          TextField(
            controller: _ctrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              color: textColor,
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixText: '\$  ',
              prefixStyle: const TextStyle(
                color: AppTheme.neonPurple,
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
              hintText: '0',
              hintStyle: TextStyle(
                color: textColor.withValues(alpha: .2),
                fontSize: 32,
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

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(_ctrl.text) ?? 0;
                if (amount > 0) {
                  await provider.setGoalForMonth(amount, widget.monthKey);
                  if (context.mounted) Navigator.pop(context);
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
                'Save Goal',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
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
      ),
    );
  }
}

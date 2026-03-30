import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class SetIncomeSheet extends StatefulWidget {
  const SetIncomeSheet({super.key});

  @override
  State<SetIncomeSheet> createState() => _SetIncomeSheetState();
}

class _SetIncomeSheetState extends State<SetIncomeSheet> {
  final _ctrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    final income = context.read<ExpenseProvider>().currentMonthIncome;
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
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This will be used to calculate your remaining balance.',
            style: TextStyle(
              fontSize: 13,
              color: textColor.withValues(alpha: 0.5),
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
                fontWeight: FontWeight.w600,
              ),
              hintText: '0',
              hintStyle: TextStyle(
                color: textColor.withValues(alpha: 0.2),
                fontSize: 24,
                fontWeight: FontWeight.w600,
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

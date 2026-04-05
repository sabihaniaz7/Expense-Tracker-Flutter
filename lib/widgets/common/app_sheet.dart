import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import '../../theme/app_theme.dart';

/// A standard bottom sheet container with glassmorphism or neon effects.
class AppSheet extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets? padding;

  const AppSheet({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final isDark = provider.isDarkMode;
    final bg = isDark ? AppTheme.darkCard : AppTheme.lightSurface;

    return Container(
      padding:
          padding ??
          EdgeInsets.only(
            left: AppTheme.sp24,
            right: AppTheme.sp24,
            top: AppTheme.sp20,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.sp28,
          ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.rad28),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            // Handle
            Center(
              child: Container(
                width: AppTheme.sp40,
                height: AppTheme.sp4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.lightText.withValues(alpha: 0.24)
                      : AppTheme.lightSubText.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppTheme.rad2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.sp24),
            ...children,
          ],
        ),
      ),
    );
  }
}

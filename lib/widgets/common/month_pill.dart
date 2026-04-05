import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// A selectable pill widget for month-based filtering in the dashboard.
class MonthPill extends StatelessWidget {
  final String label;

  const MonthPill({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.sp10,
        vertical: AppTheme.sp4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.neonPurple,
        borderRadius: BorderRadius.circular(AppTheme.rad20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.lightSurface,
          fontSize: AppTheme.fs14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

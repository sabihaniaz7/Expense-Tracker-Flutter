import 'package:expense_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  final String label;
  final Color color;

  const InputLabel({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.sp8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppTheme.fs13,
          fontWeight: FontWeight.w500,
          color: color.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

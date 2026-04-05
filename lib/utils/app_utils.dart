import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Common utility functions and formatting helpers for the application.

/// Static class providing formatting and helper methods.
class AppUtils {
  static void showSnackbar(BuildContext context, String message, {bool isError = false}) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: AppTheme.fs14,
          ),
        ),
        backgroundColor: isError ? AppTheme.dangerRed : AppTheme.safeGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.rad12),
        ),
        margin: const EdgeInsets.all(AppTheme.sp16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// A custom styled text input field with consistent theme integration.
class AppInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDark;
  final Color textColor;
  final TextInputType? keyboardType;
  final String? prefixText;
  final double fontSize;
  final FontWeight fontWeight;
  final String? Function(String?)? validator;
  final bool autofocus;

  const AppInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.isDark,
    required this.textColor,
    this.keyboardType,
    this.prefixText,
    this.fontSize = AppTheme.fs15,
    this.fontWeight = FontWeight.w500,
    this.validator,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      autofocus: autofocus,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        hintStyle: TextStyle(
          color: textColor.withValues(alpha: 0.3),
          fontSize: fontSize,
        ),
        filled: true,
        fillColor: isDark ? AppTheme.darkSurface : AppTheme.lightBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.rad14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.sp16,
          vertical: AppTheme.sp14,
        ),
      ),
    );
  }
}

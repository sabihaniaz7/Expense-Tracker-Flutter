import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

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
    this.fontSize = 15,
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
        fillColor: isDark ? AppTheme.darkSurface : const Color(0xFFF5F5FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

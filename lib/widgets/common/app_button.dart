import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isExpanded;
  final Color backgroundColor;
  final Color foregroundColor;
  final double verticalPadding;
  final double fontSize;
  final FontWeight fontWeight;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isExpanded = true,
    this.backgroundColor = AppTheme.neonPurple,
    this.foregroundColor = Colors.white,
    this.verticalPadding = 16,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
      ),
    );

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

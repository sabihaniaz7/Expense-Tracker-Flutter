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
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: color.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

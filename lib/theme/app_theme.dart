import 'package:flutter/material.dart';

const String _font = 'Syne';

TextStyle _ts({
  required Color color,
  required double size,
  required FontWeight weight,
}) => TextStyle(color: color, fontSize: size, fontWeight: weight);

class AppTheme {
  // Dark Neon Palette
  static const Color darkBg = Color(0xFF17181F);
  static const Color darkCard = Color(0xFF1E1F2A);
  static const Color darkSurface = Color(0xFF252633);
  static const Color neonPurple = Color(0xFF6C72CB);
  static const Color neonPink = Color(0xFFCB69C1);
  static const Color lightText = Color(0xFFEEEDF0);
  static const Color subText = Color(0xFF9B9BB0);

  // Warning colors
  static const Color safeGreen = Color(0xFF4CAF96);
  static const Color warningYellow = Color(0xFFFFD166);
  static const Color warningOrange = Color(0xFFFF9F43);
  static const Color dangerRed = Color(0xFFFF6B6B);

  // Category colors
  static const List<Color> categoryColors = [
    Color(0xFF6C72CB), // Purple  – Food
    Color(0xFFCB69C1), // Pink    – Entertainment
    Color(0xFFFF9F43), // Orange  – Transport
    Color(0xFF4CAF96), // Green   – Shopping
    Color(0xFF54A0FF), // Blue    – Bills
    Color(0xFFFF6B6B), // Red     – Health
    Color(0xFFFFD166), // Yellow  – Education
    Color(0xFF5F27CD), // D.Purple– Travel
    Color(0xFF00D2D3), // Cyan    – Others
  ];
  // -- DARK THEME

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    fontFamily: _font,
    colorScheme: const ColorScheme.dark(
      primary: neonPurple,
      secondary: neonPink,
      surface: darkCard,
    ),
    textTheme: TextTheme(
      displayLarge: _ts(color: lightText, size: 32, weight: FontWeight.w800),
      headlineMedium: _ts(color: lightText, size: 24, weight: FontWeight.w700),
      titleLarge: _ts(color: lightText, size: 18, weight: FontWeight.w600),
      bodyLarge: _ts(color: lightText, size: 16, weight: FontWeight.w400),
      bodyMedium: _ts(color: lightText, size: 14, weight: FontWeight.w400),
      bodySmall: _ts(color: subText, size: 12, weight: FontWeight.w400),
      labelLarge: _ts(color: lightText, size: 14, weight: FontWeight.w600),
    ),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      elevation: 0,
      iconTheme: IconThemeData(color: lightText),
    ),
  );
  // ── Light theme ─────────────────────────────────────────────────────────────
  static const Color _lightText = Color(0xFF1A1A2E);
  static const Color _lightSub = Color(0xFF8888A0);
  static const Color _lightBody = Color(0xFF3A3A5C);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5FA),
    fontFamily: _font,
    colorScheme: const ColorScheme.light(
      primary: neonPurple,
      secondary: neonPink,
      surface: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: _ts(color: _lightText, size: 32, weight: FontWeight.w800),
      headlineMedium: _ts(color: _lightText, size: 24, weight: FontWeight.w700),
      titleLarge: _ts(color: _lightText, size: 18, weight: FontWeight.w600),
      bodyLarge: _ts(color: _lightBody, size: 16, weight: FontWeight.w400),
      bodyMedium: _ts(color: _lightBody, size: 14, weight: FontWeight.w400),
      bodySmall: _ts(color: _lightSub, size: 12, weight: FontWeight.w400),
      labelLarge: _ts(color: _lightText, size: 14, weight: FontWeight.w600),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F5FA),
      elevation: 0,
      iconTheme: IconThemeData(color: _lightText),
    ),
  );
}

// Categories Data
class AppCategories {
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Food & Drink', 'icon': '🍕', 'colorIndex': 0},
    {'name': 'Entertainment', 'icon': '🎮', 'colorIndex': 1},
    {'name': 'Transport', 'icon': '🚗', 'colorIndex': 2},
    {'name': 'Shopping', 'icon': '🛍️', 'colorIndex': 3},
    {'name': 'Bills', 'icon': '💡', 'colorIndex': 4},
    {'name': 'Health', 'icon': '❤️', 'colorIndex': 5},
    {'name': 'Education', 'icon': '📚', 'colorIndex': 6},
    {'name': 'Travel', 'icon': '✈️', 'colorIndex': 7},
    {'name': 'Others', 'icon': '📦', 'colorIndex': 8},
  ];
  static String getEmoji(String categoryName) {
    final category = categories.firstWhere(
      (c) => c['name'] == categoryName,
      orElse: () => {'icon': '📦', 'colorIndex': 8},
    );
    return category['icon'];
  }

  static Color getColor(String categoryName) {
    final category = categories.firstWhere(
      (c) => c['name'] == categoryName,
      orElse: () => {'icon': '📦', 'colorIndex': 8},
    );
    return AppTheme.categoryColors[category['colorIndex'] as int];
  }
}

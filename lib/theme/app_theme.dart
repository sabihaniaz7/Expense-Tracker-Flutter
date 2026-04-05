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

  // Light Neon Palette
  static const Color lightPrimaryText = Color(0xFF1A1A2E);
  static const Color lightSubText = Color(0xFF8888A0);
  static const Color lightBodyText = Color(0xFF3A3A5C);
  static const Color lightBg = Color(0xFFF5F5FA);
  static const Color lightSurface = Colors.white;
  static const Color lightAccent = Color(0xFFEEECFF);
  static const Color lightAccentSecondary = Color(0xFFF3F0FF);

  // Warning colors
  static const Color safeGreen = Color(0xFF4CAF96);
  static const Color warningYellow = Color(0xFFFFD166);
  static const Color warningOrange = Color(0xFFFF9F43);
  static const Color dangerRed = Color(0xFFFF6B6B);

  // Spacing / Tokens
  static const double sp4 = 4.0;
  static const double sp5 = 5.0;
  static const double sp6 = 6.0;
  static const double sp8 = 8.0;
  static const double sp10 = 10.0;
  static const double sp12 = 12.0;
  static const double sp13 = 13.0;
  static const double sp14 = 14.0;
  static const double sp15 = 15.0;
  static const double sp16 = 16.0;
  static const double sp18 = 18.0;
  static const double sp20 = 20.0;
  static const double sp24 = 24.0;
  static const double sp28 = 28.0;
  static const double sp32 = 32.0;
  static const double sp36 = 36.0;
  static const double sp40 = 40.0;
  static const double sp44 = 44.0;
  static const double sp46 = 46.0;
  static const double sp50 = 50.0;
  static const double sp56 = 56.0;
  static const double sp60 = 60.0;
  static const double sp75 = 75.0;
  static const double sp80 = 80.0;
  static const double sp90 = 90.0;
  static const double sp220 = 220.0;

  // Radius Tokens
  static const double rad2 = 2.0;
  static const double rad4 = 4.0;
  static const double rad8 = 8.0;
  static const double rad10 = 10.0;
  static const double rad12 = 12.0;
  static const double rad14 = 14.0;
  static const double rad16 = 16.0;
  static const double rad18 = 18.0;
  static const double rad20 = 20.0;
  static const double rad22 = 22.0;
  static const double rad24 = 24.0;
  static const double rad28 = 28.0;

  // Font Size Tokens
  static const double fs10 = 10.0;
  static const double fs11 = 11.0;
  static const double fs12 = 12.0;
  static const double fs13 = 13.0;
  static const double fs14 = 14.0;
  static const double fs15 = 15.0;
  static const double fs16 = 16.0;
  static const double fs17 = 17.0;
  static const double fs18 = 18.0;
  static const double fs20 = 20.0;
  static const double fs22 = 22.0;
  static const double fs24 = 24.0;
  static const double fs32 = 32.0;

  // Durations
  static const Duration durFast = Duration(milliseconds: 180);
  static const Duration durStandard = Duration(milliseconds: 200);

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
      displayLarge: _ts(color: lightText, size: fs32, weight: FontWeight.w800),
      headlineMedium: _ts(
        color: lightText,
        size: fs24,
        weight: FontWeight.w700,
      ),
      titleLarge: _ts(color: lightText, size: fs18, weight: FontWeight.w600),
      bodyLarge: _ts(color: lightText, size: fs16, weight: FontWeight.w400),
      bodyMedium: _ts(color: lightText, size: fs14, weight: FontWeight.w400),
      bodySmall: _ts(color: subText, size: fs12, weight: FontWeight.w400),
      labelLarge: _ts(color: lightText, size: fs14, weight: FontWeight.w600),
    ),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rad20)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      elevation: 0,
      iconTheme: IconThemeData(color: lightText),
    ),
  );

  // ── Light theme ─────────────────────────────────────────────────────────────
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBg,
    fontFamily: _font,
    colorScheme: const ColorScheme.light(
      primary: neonPurple,
      secondary: neonPink,
      surface: lightSurface,
    ),
    textTheme: TextTheme(
      displayLarge: _ts(
        color: lightPrimaryText,
        size: fs32,
        weight: FontWeight.w800,
      ),
      headlineMedium: _ts(
        color: lightPrimaryText,
        size: fs24,
        weight: FontWeight.w700,
      ),
      titleLarge: _ts(
        color: lightPrimaryText,
        size: fs18,
        weight: FontWeight.w600,
      ),
      bodyLarge: _ts(color: lightBodyText, size: fs16, weight: FontWeight.w400),
      bodyMedium: _ts(
        color: lightBodyText,
        size: fs14,
        weight: FontWeight.w400,
      ),
      bodySmall: _ts(color: lightSubText, size: fs12, weight: FontWeight.w400),
      labelLarge: _ts(
        color: lightPrimaryText,
        size: fs14,
        weight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 0,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rad20)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBg,
      elevation: 0,
      iconTheme: IconThemeData(color: lightPrimaryText),
    ),
  );
}

// Categories Data
class AppCategories {
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Food & Drink', 'icon': '🍔', 'colorIndex': 0},
    {'name': 'Entertainment', 'icon': '🍿', 'colorIndex': 1},
    {'name': 'Transport', 'icon': '🚕', 'colorIndex': 2},
    {'name': 'Shopping', 'icon': '🛒', 'colorIndex': 3},
    {'name': 'Bills', 'icon': '🧾', 'colorIndex': 4},
    {'name': 'Health', 'icon': '🏥', 'colorIndex': 5},
    {'name': 'Education', 'icon': '📚', 'colorIndex': 6},
    {'name': 'Travel', 'icon': '🌍', 'colorIndex': 7},
    {'name': 'Others', 'icon': '✨', 'colorIndex': 8},
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

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Manages category data, emojis, and dynamic color assignment.
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
  ];

  static String getEmoji(String categoryName) {
    // 1. Check if the categoryName starts with a custom emoji (e.g., "🎮 Gaming")
    final regex = RegExp(
      r'^(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );
    final match = regex.firstMatch(categoryName);
    if (match != null) {
      return match.group(0)!;
    }

    // 2. Fallback to static list
    try {
      final category = categories.firstWhere((c) => c['name'] == categoryName);
      return category['icon'];
    } catch (_) {
      return '✨';
    }
  }

  static String stripEmoji(String categoryName) {
    final emoji = getEmoji(categoryName);
    if (categoryName.startsWith(emoji) && categoryName.length > emoji.length) {
      return categoryName.substring(emoji.length).trim();
    }
    return categoryName;
  }

  static Color getColor(String categoryName) {
    // 1. Check if it's a predefined category
    try {
      final category = categories.firstWhere((c) => c['name'] == categoryName);
      return AppTheme.categoryColors[category['colorIndex'] as int];
    } catch (_) {
      // 2. For custom categories, use the DEDICATED custom palette
      final int hash = categoryName.hashCode.abs();
      final int colorIndex = hash % AppTheme.customCategoryColors.length;
      return AppTheme.customCategoryColors[colorIndex];
    }
  }

  static List<String> getSuggestions(String query) {
    final q = query.toLowerCase();
    final Map<String, List<String>> keywordMap = {
      'food': ['🍔', '🍕', '🍎', '🍣'],
      'drink': ['☕', '🍹', '🍺', '🥤'],
      'home': ['🏠', '🛋️', '🔑', '🧹'],
      'rent': ['🏠', '🏢', '📑'],
      'pet': ['🐶', '🐱', '🐹', '🐾'],
      'car': ['🚗', '⛽', '🛠️', '🧼'],
      'travel': ['✈️', '🏨', '🏖️', '🎒'],
      'gift': ['🎁', '🎈', '🎉', '🧸'],
      'birthday': ['🎂', '🍰', '🎁'],
      'health': ['💊', '🏥', '🧘', '🦷'],
      'gym': ['🏋️', '🏃', '🚴', '💪'],
      'game': ['🎮', '🎲', '🕹️', '👾'],
      'shop': ['🛒', '🛍️', '👕', '👠'],
      'work': ['💻', '📎', '💼', '📊'],
      'bill': ['🧾', '💳', '🏦', '📉'],
      'sub': ['📺', '🎵', '☁️', '📱'],
      'edu': ['📚', '🎓', '✏️', '🖍️'],
      'beauty': ['💄', '💅', '💇', '🧴'],
    };

    final List<String> suggestions = [];
    keywordMap.forEach((key, emojis) {
      if (q.contains(key)) {
        suggestions.addAll(emojis);
      }
    });

    final defaults = ['✨', '💰', '🏷️', '💎', '🔥', '🌈', '⭐', '🍀'];
    return (suggestions.toSet().toList() + defaults).take(8).toList();
  }
}

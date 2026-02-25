import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';

enum ReadingTheme { white, sepia, night }

final readingThemeProvider = StateProvider<ReadingTheme>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final themeName = prefs.getString('reading_theme') ?? 'white';
  return ReadingTheme.values.firstWhere((e) => e.name == themeName, orElse: () => ReadingTheme.white);
});

extension ReadingThemeExtension on ReadingTheme {
  Color get backgroundColor {
    switch (this) {
      case ReadingTheme.white: return Colors.white;
      case ReadingTheme.sepia: return const Color(0xFFF4ECD8);
      case ReadingTheme.night: return const Color(0xFF121212);
    }
  }

  Color get textColor {
    switch (this) {
      case ReadingTheme.white: return Colors.black;
      case ReadingTheme.sepia: return const Color(0xFF5B4636);
      case ReadingTheme.night: return const Color(0xFFE0E0E0);
    }
  }
}

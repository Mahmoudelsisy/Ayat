import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedFontProvider = StateProvider<String>((ref) => 'Cairo');

final quranFontSizeProvider = StateProvider<double>((ref) => 24.0);
final tafsirFontSizeProvider = StateProvider<double>((ref) => 16.0);

final availableFonts = [
  'Cairo',
  'Amiri',
  'Katibeh',
  'Lateef',
  'Reem Kufi',
  'Aref Ruqaa',
];

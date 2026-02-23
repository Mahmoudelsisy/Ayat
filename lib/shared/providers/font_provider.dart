import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedFontProvider = StateProvider<String>((ref) => 'Cairo');

final availableFonts = [
  'Cairo',
  'Amiri',
  'Katibeh',
  'Lateef',
  'Reem Kufi',
  'Aref Ruqaa',
];

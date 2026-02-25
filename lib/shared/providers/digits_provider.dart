import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';

final arabicDigitsProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool('arabic_digits') ?? false;
});

extension ArabicDigitExtension on String {
  String toArabicDigits(bool enabled) {
    if (!enabled) return this;
    const latin = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = this;
    for (int i = 0; i < latin.length; i++) {
      result = result.replaceAll(latin[i], arabic[i]);
    }
    return result;
  }
}

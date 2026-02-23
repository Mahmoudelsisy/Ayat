import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';

final selectedReadingProvider = StateProvider<String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getString('quran_reading') ?? 'quran-uthmani';
});

final availableReadings = {
  'quran-uthmani': 'حفص عن عاصم',
  'quran-warsh-nafi-mus' : 'ورش عن نافع',
  'quran-qaloon-nafi-mus' : 'قالون عن نافع',
};

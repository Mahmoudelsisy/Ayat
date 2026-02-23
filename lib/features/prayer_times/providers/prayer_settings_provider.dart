import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import 'package:adhan/adhan.dart';

class PrayerSettings {
  final CalculationMethod method;
  final Madhab madhab;

  PrayerSettings({required this.method, required this.madhab});
}

final prayerSettingsProvider = StateProvider<PrayerSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final methodName = prefs.getString('prayer_method') ?? 'umm_al_qura';
  final madhabName = prefs.getString('prayer_madhab') ?? 'shafi';

  CalculationMethod method;
  switch (methodName) {
    case 'muslim_world_league': method = CalculationMethod.muslim_world_league; break;
    case 'egyptian': method = CalculationMethod.egyptian; break;
    case 'karachi': method = CalculationMethod.karachi; break;
    case 'dubai': method = CalculationMethod.dubai; break;
    case 'kuwait': method = CalculationMethod.kuwait; break;
    case 'qatar': method = CalculationMethod.qatar; break;
    case 'singapore': method = CalculationMethod.singapore; break;
    case 'turkey': method = CalculationMethod.turkey; break;
    default: method = CalculationMethod.umm_al_qura;
  }

  Madhab madhab = madhabName == 'hanafi' ? Madhab.hanafi : Madhab.shafi;

  return PrayerSettings(method: method, madhab: madhab);
});

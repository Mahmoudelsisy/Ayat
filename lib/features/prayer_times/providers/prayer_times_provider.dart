import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';

final prayerTimesProvider = FutureProvider<PrayerTimes>((ref) async {
  final service = PrayerTimesService();
  final times = await service.getPrayerTimes();
  await service.schedulePrayerNotifications(times);
  return times;
});

class PrayerTimesService {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<PrayerTimes> getPrayerTimes() async {
    final position = await _determinePosition();
    final coordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);
    return prayerTimes;
  }

  Future<void> schedulePrayerNotifications(PrayerTimes times) async {
    final notificationService = NotificationService();
    await notificationService.cancelAll();

    // Azkar Reminders
    await notificationService.scheduleDailyNotification(100, 'أذكار الصباح', 'حان الآن موعد أذكار الصباح', 7, 0);
    await notificationService.scheduleDailyNotification(101, 'أذكار المساء', 'حان الآن موعد أذكار المساء', 17, 0);

    final prayers = {
      'الفجر': times.fajr,
      'الظهر': times.dhuhr,
      'العصر': times.asr,
      'المغرب': times.maghrib,
      'العشاء': times.isha,
    };

    int id = 0;
    prayers.forEach((name, time) {
      if (time.isAfter(DateTime.now())) {
        notificationService.scheduleNotification(
          id++,
          'حان الآن موعد صلاة $name',
          'الصلاة خير من النوم${name == 'الفجر' ? ' (الفجر)' : ''}',
          time,
        );
      }
    });
  }
}

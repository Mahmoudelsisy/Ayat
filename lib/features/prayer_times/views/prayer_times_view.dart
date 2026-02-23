import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import '../providers/prayer_times_provider.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';

class PrayerTimesView extends ConsumerWidget {
  const PrayerTimesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimesAsync = ref.watch(prayerTimesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
      ),
      body: prayerTimesAsync.when(
        data: (times) => _buildTimesList(context, times),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
    );
  }

  Widget _buildTimesList(BuildContext context, PrayerTimes times) {
    final format = intl.DateFormat.jm('ar');
    final hijriDate = HijriCalendar.now();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} هـ',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  intl.DateFormat.yMMMMd('ar').format(DateTime.now()),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildPrayerTile('الفجر', format.format(times.fajr), context),
        _buildPrayerTile('الشروق', format.format(times.sunrise), context),
        _buildPrayerTile('الظهر', format.format(times.dhuhr), context),
        _buildPrayerTile('العصر', format.format(times.asr), context),
        _buildPrayerTile('المغرب', format.format(times.maghrib), context),
        _buildPrayerTile('العشاء', format.format(times.isha), context),
      ],
    );
  }

  Widget _buildPrayerTile(String name, String time, BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(time, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18)),
      ),
    );
  }
}

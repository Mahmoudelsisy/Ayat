import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import 'package:drift/drift.dart' as drift hide Column;
import 'package:hijri/hijri_calendar.dart';
import '../../modes/views/modes_screen.dart';

final readAyahsCountProvider = FutureProvider<int>((ref) async {
  final db = ref.read(databaseProvider);
  final countExp = db.userProgress.id.count();
  final query = db.selectOnly(db.userProgress)..addColumns([countExp]);
  final result = await query.getSingle();
  return result.read(countExp) ?? 0;
});

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readCountAsync = ref.watch(readAyahsCountProvider);
    const totalAyahs = 6236;

    return Scaffold(
      appBar: AppBar(title: const Text('آيات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCommitmentStats(),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('تقدم الختمة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  readCountAsync.when(
                    data: (count) {
                      final progress = count / totalAyahs;
                      return Column(
                        children: [
                          LinearProgressIndicator(value: progress, minHeight: 10),
                          const SizedBox(height: 10),
                          Text('تمت قراءة $count من $totalAyahs آية (${(progress * 100).toStringAsFixed(1)}%)'),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (err, stack) => Text('خطأ: $err'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildRamadanCountdown(),
          const SizedBox(height: 20),
          _buildQuickAction(context, 'الأوضاع الخاصة (قيام، خلوة)', Icons.brightness_4, Colors.purple, destination: const ModesScreen()),
          _buildQuickAction(context, 'أذكار الصباح', Icons.wb_sunny, Colors.orange),
          _buildQuickAction(context, 'أذكار المساء', Icons.nightlight_round, Colors.indigo),
          _buildQuickAction(context, 'سورة الكهف', Icons.menu_book, Colors.green),
        ],
      ),
    );
  }

  Widget _buildRamadanCountdown() {
    final hijriNow = HijriCalendar.now();
    int daysToRamadan;

    if (hijriNow.hMonth < 9) {
      // Ramadan is month 9
      // Simplistic calculation: assume 30 days per month
      daysToRamadan = (9 - hijriNow.hMonth - 1) * 30 + (30 - hijriNow.hDay);
    } else if (hijriNow.hMonth == 9) {
      daysToRamadan = 0; // It is Ramadan!
    } else {
      daysToRamadan = (12 - hijriNow.hMonth + 8) * 30 + (30 - hijriNow.hDay);
    }

    return Card(
      color: Colors.green[100],
      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.orange),
        title: Text(daysToRamadan == 0 ? 'رمضان مبارك!' : 'باقي على رمضان $daysToRamadan يوم'),
        subtitle: const Text('اللهم بلغنا رمضان'),
      ),
    );
  }

  Widget _buildCommitmentStats() {
    return Card(
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('مؤشرات الالتزام اليومي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('الصلوات', '5/5', Icons.mosque, Colors.green),
                _buildStatItem('الأذكار', '2/2', Icons.favorite, Colors.red),
                _buildStatItem('الورد', '10ص', Icons.menu_book, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, Color color, {Widget? destination}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          if (destination != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => destination));
          }
        },
      ),
    );
  }
}

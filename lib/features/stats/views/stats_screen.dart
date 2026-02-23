import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import '../../../main.dart';
import 'package:drift/drift.dart';

final weeklyStatsProvider = FutureProvider<List<double>>((ref) async {
  final db = ref.read(databaseProvider);
  final now = DateTime.now();
  final last7Days = List.generate(7, (i) => now.subtract(Duration(days: i)));

  List<double> counts = [];
  for (var day in last7Days.reversed) {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final countExp = db.userProgress.id.count();
    final query = db.selectOnly(db.userProgress)
      ..addColumns([countExp])
      ..where(db.userProgress.timestamp.isBetweenValues(startOfDay, endOfDay));

    final result = await query.getSingle();
    counts.add((result.read(countExp) as num? ?? 0).toDouble());
  }
  return counts;
});

final heatmapStatsProvider = FutureProvider<Map<DateTime, int>>((ref) async {
  final db = ref.read(databaseProvider);
  final query = await db.select(db.userProgress).get();

  Map<DateTime, int> dataset = {};
  for (var item in query) {
    final date = DateTime(item.timestamp.year, item.timestamp.month, item.timestamp.day);
    dataset[date] = (dataset[date] ?? 0) + 1;
  }
  return dataset;
});

final totalAyahsReadProvider = FutureProvider<int>((ref) async {
  final db = ref.read(databaseProvider);
  final countExp = db.userProgress.id.count();
  final query = db.selectOnly(db.userProgress)..addColumns([countExp]);
  final result = await query.getSingle();
  return (result.read(countExp) ?? 0).toInt();
});

final currentStreakProvider = FutureProvider<int>((ref) async {
  final db = ref.read(databaseProvider);
  final query = await (db.select(db.userProgress)..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).get();

  if (query.isEmpty) return 0;

  Set<DateTime> uniqueDates = query.map((e) => DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day)).toSet();

  int streak = 0;
  DateTime current = DateTime.now();
  current = DateTime(current.year, current.month, current.day);

  if (!uniqueDates.contains(current)) {
    current = current.subtract(const Duration(days: 1));
  }

  while (uniqueDates.contains(current)) {
    streak++;
    current = current.subtract(const Duration(days: 1));
  }

  return streak;
});

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(weeklyStatsProvider);
    final heatmapAsync = ref.watch(heatmapStatsProvider);
    final totalReadAsync = ref.watch(totalAyahsReadProvider);
    final streakAsync = ref.watch(currentStreakProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('إحصائيات الالتزام')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('خريطة الالتزام السنوية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          heatmapAsync.when(
            data: (data) => HeatMap(
              datasets: data,
              colorMode: ColorMode.opacity,
              showText: false,
              scrollable: true,
              colorsets: const {
                1: Colors.green,
              },
              onClick: (value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('نشاط يوم $value')));
              },
            ),
            loading: () => const LinearProgressIndicator(),
            error: (err, stack) => Text('خطأ: $err'),
          ),
          const SizedBox(height: 30),
          const Text('نشاط القراءة (آخر 7 أيام)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: statsAsync.when(
              data: (data) => BarChart(
                BarChartData(
                  barGroups: data.asMap().entries.map((e) => BarChartGroupData(
                        x: e.key,
                        barRods: [BarChartRodData(toY: e.value, color: Colors.green)],
                      )).toList(),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('خطأ: $err')),
            ),
          ),
          const SizedBox(height: 40),
          totalReadAsync.when(
            data: (val) => _buildSummaryCard('إجمالي الآيات المقروءة', val.toString(), Icons.menu_book, Colors.blue),
            loading: () => const CircularProgressIndicator(),
            error: (e, s) => const SizedBox(),
          ),
          streakAsync.when(
            data: (val) => _buildSummaryCard('سلسلة الالتزام الحالية', '$val أيام', Icons.flash_on, Colors.orange),
            loading: () => const CircularProgressIndicator(),
            error: (e, s) => const SizedBox(),
          ),
          totalReadAsync.when(
            data: (val) => _buildSummaryCard('متوسط القراءة اليومي', '${(val / 30).toStringAsFixed(1)} آية', Icons.show_chart, Colors.purple),
            loading: () => const CircularProgressIndicator(),
            error: (e, s) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color)),
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
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

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(weeklyStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('إحصائيات الالتزام')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
          _buildSummaryCard('إجمالي الآيات المقروءة', '124', Icons.menu_book, Colors.blue),
          _buildSummaryCard('أطول سلسلة التزام', '5 أيام', Icons.flash_on, Colors.orange),
          _buildSummaryCard('متوسط القراءة اليومي', '18 آية', Icons.show_chart, Colors.purple),
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

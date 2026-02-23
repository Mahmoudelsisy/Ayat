import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';

final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final db = ref.read(databaseProvider);
  return await db.select(db.achievements).get();
});

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الإنجازات')),
      body: achievementsAsync.when(
        data: (list) => list.isEmpty
            ? _buildEmptyState()
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final a = list[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIconData(a.icon),
                            size: 50,
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            a.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            a.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text('لا توجد إنجازات بعد. استمر في القراءة والعبادة!', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'star': return Icons.star;
      case 'book': return Icons.menu_book;
      case 'timer': return Icons.timer;
      case 'fire': return Icons.whatshot;
      default: return Icons.emoji_events;
    }
  }
}

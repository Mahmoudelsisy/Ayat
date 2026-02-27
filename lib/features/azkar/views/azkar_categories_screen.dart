import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';
import 'package:drift/drift.dart' hide Column;
import 'azkar_list_screen.dart';
import '../../tasbeeh/views/tasbeeh_view.dart'; // I will create this

final azkarCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final db = ref.read(databaseProvider);
  final query = db.selectOnly(db.azkar, distinct: true)..addColumns([db.azkar.category]);
  final result = await query.get();
  return result.map((row) => row.read(db.azkar.category)!).toList();
});

class AzkarCategoriesScreen extends ConsumerWidget {
  const AzkarCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(azkarCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار'),
        actions: [
          IconButton(
            icon: const Icon(Icons.plus_one),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TasbeehView()),
              );
            },
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AzkarListScreen(category: category),
                    ),
                  );
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuranDuasScreen(),
            ),
          );
        },
        label: const Text('أدعية قرآنية'),
        icon: const Icon(Icons.auto_stories),
      ),
    );
  }
}

class QuranDuasScreen extends ConsumerWidget {
  const QuranDuasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('أدعية من القرآن')),
      body: FutureBuilder<List<QuranData>>(
        future: _fetchQuranDuas(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        item.verseText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontFamily: 'Amiri', height: 1.8),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'سورة ${item.surahNumber} - آية ${item.ayahNumber}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<QuranData>> _fetchQuranDuas(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    return await (db.select(db.quran)
          ..where((t) => t.verseText.like('%رَبَّنَا%') | t.verseText.like('%رَبِّ%'))
          ..limit(50))
        .get();
  }
}

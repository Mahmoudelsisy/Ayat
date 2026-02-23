import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
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
    );
  }
}

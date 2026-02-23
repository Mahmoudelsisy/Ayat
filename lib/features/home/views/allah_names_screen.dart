import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';

final allahNamesProvider = FutureProvider<List<AllahName>>((ref) async {
  final db = ref.read(databaseProvider);
  return await db.select(db.allahNames).get();
});

class AllahNamesScreen extends ConsumerWidget {
  const AllahNamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namesAsync = ref.watch(allahNamesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('أسماء الله الحسنى')),
      body: namesAsync.when(
        data: (names) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: names.length,
          itemBuilder: (context, index) {
            final name = names[index];
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(name.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, color: Colors.green)),
                    content: Text(name.meaning, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
                    ],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Text(
                    name.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';
import '../../../core/utils/arabic_utils.dart';

final allahNamesProvider = FutureProvider<List<AllahName>>((ref) async {
  final db = ref.read(databaseProvider);
  return await db.select(db.allahNames).get();
});

class AllahNamesScreen extends ConsumerStatefulWidget {
  const AllahNamesScreen({super.key});

  @override
  ConsumerState<AllahNamesScreen> createState() => _AllahNamesScreenState();
}

class _AllahNamesScreenState extends ConsumerState<AllahNamesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final namesAsync = ref.watch(allahNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('أسماء الله الحسنى'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن اسم من أسماء الله...',
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
        ),
      ),
      body: namesAsync.when(
        data: (names) {
          final normalizedQuery = ArabicUtils.normalize(_searchQuery);
          final filtered = names.where((n) {
            final matchName = n.name.contains(_searchQuery);
            final matchPlain = n.namePlain?.contains(normalizedQuery) ?? false;
            final matchMeaning = n.meaning.contains(_searchQuery);
            return matchName || matchPlain || matchMeaning;
          }).toList();
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final name = filtered[index];
              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(name.name,
                          textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, color: Colors.green)),
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
    );
  }
}

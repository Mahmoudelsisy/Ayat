import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';

final mushafPagesProvider = FutureProvider.family<List<int>, int>((ref, surahNumber) async {
  final db = ref.read(databaseProvider);
  final query = db.selectOnly(db.quran, distinct: true)
    ..addColumns([db.quran.pageNumber])
    ..where(db.quran.surahNumber.equals(surahNumber));
  final result = await query.get();
  return result.map((row) => row.read(db.quran.pageNumber)!).toList();
});

class MushafView extends ConsumerWidget {
  final int surahNumber;
  const MushafView({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesAsync = ref.watch(mushafPagesProvider(surahNumber));

    return pagesAsync.when(
      data: (pages) => PageView.builder(
        reverse: true, // Mushaf is right to left
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final pageNum = pages[index];
          final url = 'https://raw.githubusercontent.com/m4hmoud-atef/Islamic-and-quran-data/main/quran_images/quran_images_1/$pageNum.png';
          return Center(
            child: InteractiveViewer(
              child: Image.network(
                url,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }
}

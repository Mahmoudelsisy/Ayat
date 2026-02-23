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

class MushafView extends ConsumerStatefulWidget {
  final int surahNumber;
  const MushafView({super.key, required this.surahNumber});

  @override
  ConsumerState<MushafView> createState() => _MushafViewState();
}

class _MushafViewState extends ConsumerState<MushafView> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pagesAsync = ref.watch(mushafPagesProvider(widget.surahNumber));

    return pagesAsync.when(
      data: (pages) => Stack(
        children: [
          PageView.builder(
            reverse: true, // Mushaf is right to left
            itemCount: pages.length,
            onPageChanged: (index) => setState(() => _currentPageIndex = index),
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
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'صفحة ${pages[_currentPageIndex]}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }
}

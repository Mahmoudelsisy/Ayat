import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';
import '../../quran/views/surah_detail_screen.dart';

final bookmarksProvider = FutureProvider<List<Bookmark>>((ref) async {
  final db = ref.read(databaseProvider);
  return await db.select(db.bookmarks).get();
});

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('المرجعيات')),
      body: bookmarksAsync.when(
        data: (bookmarks) => bookmarks.isEmpty
            ? const Center(child: Text('لا توجد مرجعيات بعد'))
            : ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final b = bookmarks[index];
                  return ListTile(
                    title: Text('سورة ${b.surahNumber} - آية ${b.ayahNumber}'),
                    subtitle: Text('تم الحفظ في: ${b.timestamp}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final db = ref.read(databaseProvider);
                        await (db.delete(db.bookmarks)..where((t) => t.id.equals(b.id))).go();
                        ref.invalidate(bookmarksProvider);
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SurahDetailScreen(
                          surahNumber: b.surahNumber,
                          surahName: "سورة ${b.surahNumber}",
                        ),
                      ));
                    },
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
    );
  }
}

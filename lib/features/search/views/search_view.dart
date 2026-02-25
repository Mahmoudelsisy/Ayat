import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';
import 'package:drift/drift.dart' hide Column;
import '../../quran/views/surah_detail_screen.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final _searchController = TextEditingController();
  List<QuranData> _quranResults = [];
  List<Tafsir> _tafsirResults = [];
  bool _isSearching = false;

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _quranResults = [];
        _tafsirResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);

    final db = ref.read(databaseProvider);

    // Search Quran
    final quranQuery = db.select(db.quran)..where((t) => t.verseText.like('%$query%'))..limit(50);
    final quranResults = await quranQuery.get();

    // Search Tafsir
    final tafsirQuery = db.select(db.tafsirs)..where((t) => t.tafsirText.like('%$query%'))..limit(50);
    final tafsirResults = await tafsirQuery.get();

    if (mounted) {
      setState(() {
        _quranResults = quranResults;
        _tafsirResults = tafsirResults;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'ابحث في القرآن أو التفسير...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _performSearch,
        ),
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'آيات'),
                      Tab(text: 'تفسير'),
                    ],
                    labelColor: Colors.green,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildQuranList(),
                        _buildTafsirList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildQuranList() {
    if (_quranResults.isEmpty) {
      return const Center(child: Text('لا توجد نتائج في الآيات'));
    }
    return ListView.builder(
      itemCount: _quranResults.length,
      itemBuilder: (context, index) {
        final ayah = _quranResults[index];
        return ListTile(
          title: _highlightText(ayah.verseText, _searchController.text, isQuran: true),
          subtitle: Text('سورة ${ayah.surahNumber} - آية ${ayah.ayahNumber}', textAlign: TextAlign.right),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SurahDetailScreen(
                surahNumber: ayah.surahNumber,
                surahName: 'سورة ${ayah.surahNumber}',
                filter: QuranFilter(QuranFilterType.surah, ayah.surahNumber, 'سورة ${ayah.surahNumber}'),
                initialAyahNumber: ayah.ayahNumber,
              ),
            ));
          },
        );
      },
    );
  }

  Widget _buildTafsirList() {
    if (_tafsirResults.isEmpty) {
      return const Center(child: Text('لا توجد نتائج في التفاسير'));
    }
    return ListView.builder(
      itemCount: _tafsirResults.length,
      itemBuilder: (context, index) {
        final tafsir = _tafsirResults[index];
        final cleanTafsir = tafsir.tafsirText.replaceAll(RegExp(r'<[^>]*>'), '');
        final snippet = cleanTafsir.substring(0, (cleanTafsir.length > 150 ? 150 : cleanTafsir.length));

        return ListTile(
          title: _highlightText('$snippet...', _searchController.text),
          subtitle: Text('سورة ${tafsir.surahNumber} - آية ${tafsir.ayahNumber} (${tafsir.type})', textAlign: TextAlign.right),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SurahDetailScreen(
                surahNumber: tafsir.surahNumber,
                surahName: 'سورة ${tafsir.surahNumber}',
                filter: QuranFilter(QuranFilterType.surah, tafsir.surahNumber, 'سورة ${tafsir.surahNumber}'),
                initialAyahNumber: tafsir.ayahNumber,
              ),
            ));
          },
        );
      },
    );
  }

  Widget _highlightText(String text, String query, {bool isQuran = false}) {
    if (query.isEmpty) {
      return Text(text, textAlign: TextAlign.right, style: TextStyle(fontFamily: isQuran ? 'Amiri' : null, fontSize: isQuran ? 18 : null));
    }

    final matches = query.split(' ').where((s) => s.isNotEmpty).toList();
    // Simplified: highlight only the first match or full query if found
    final pattern = RegExp('(${matches.join('|')})', caseSensitive: false);
    final spans = <TextSpan>[];

    text.splitMapJoin(
      pattern,
      onMatch: (m) {
        spans.add(TextSpan(text: m[0], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)));
        return '';
      },
      onNonMatch: (n) {
        spans.add(TextSpan(text: n));
        return '';
      },
    );

    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontFamily: isQuran ? 'Amiri' : null,
          fontSize: isQuran ? 18 : 16,
        ),
        children: spans,
      ),
    );
  }
}

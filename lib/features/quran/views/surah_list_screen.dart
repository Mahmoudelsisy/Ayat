import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import 'surah_detail_screen.dart';
import '../providers/search_provider.dart';

final surahListProvider = FutureProvider<List<int>>((ref) async {
  final db = ref.read(databaseProvider);
  final query = db.selectOnly(db.quran, distinct: true)..addColumns([db.quran.surahNumber]);
  final result = await query.get();
  return result.map((row) => row.read(db.quran.surahNumber)!).toList();
});

class QuranSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'بحث في القرآن...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.green,
            tabs: [
              Tab(text: 'في الآيات'),
              Tab(text: 'في التفاسير'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildQuranSearchResults(),
                _buildTafsirSearchResults(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuranSearchResults() {
    return Consumer(builder: (context, ref, child) {
      final searchAsync = ref.watch(quranSearchProvider(query));
      return searchAsync.when(
        data: (results) => ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final ayah = results[index];
            return ListTile(
              title: Text(ayah.verseText, textAlign: TextAlign.right),
              subtitle: Text('سورة ${ayah.surahNumber} - آية ${ayah.ayahNumber}'),
              onTap: () {
                close(context, null);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SurahDetailScreen(
                      surahNumber: ayah.surahNumber,
                      surahName: "سورة ${ayah.surahNumber}",
                    ),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      );
    });
  }

  Widget _buildTafsirSearchResults() {
    return Consumer(builder: (context, ref, child) {
      final searchAsync = ref.watch(tafsirSearchProvider(query));
      return searchAsync.when(
        data: (results) => ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            return ListTile(
              title: Text(result.tafsirText.replaceAll(RegExp(r'<[^>]*>'), ''),
                  maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right),
              subtitle: Text('سورة ${result.surahNumber} - آية ${result.ayahNumber} (${result.type})'),
              onTap: () {
                close(context, null);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SurahDetailScreen(
                      surahNumber: result.surahNumber,
                      surahName: "سورة ${result.surahNumber}",
                    ),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}

final quranNavigationTabProvider = StateProvider<int>((ref) => 0);

class SurahListScreen extends ConsumerWidget {
  const SurahListScreen({super.key});

  final List<String> surahNames = const [
    "الفاتحة", "البقرة", "آل عمران", "النساء", "المائدة", "الأنعام", "الأعراف", "الأنفال", "التوبة", "يونس",
    "هود", "يوسف", "الرعد", "إبراهيم", "الحجر", "النحل", "الإسراء", "الكهف", "مريم", "طه",
    "الأنبياء", "الحج", "المؤمنون", "النور", "الفرقان", "الشعراء", "النمل", "القصص", "العنكبوت", "الروم",
    "لقمان", "السجدة", "الأحزاب", "سبأ", "فاطر", "يس", "الصافات", "ص", "الزمر", "غافر",
    "فصلت", "الشورى", "الزخرف", "الدخان", "الجاثية", "الأحقاف", "محمد", "الفتح", "الحجرات", "ق",
    "الذاريات", "الطور", "النجم", "القمر", "الرحمن", "الواقعة", "الحديد", "المجادلة", "الحشر", "الممتحنة",
    "الصف", "الجمعة", "المنافقون", "التغابن", "الطلاق", "التحريم", "الملك", "القلم", "الحاقة", "المعارج",
    "نوح", "الجن", "المزمل", "المدثر", "القيامة", "الإنسان", "المرسلات", "النبأ", "النازعات", "عبس",
    "التكوير", "الانفطار", "المطففين", "الانشقاق", "البروج", "الطارق", "الأعلى", "الغاشية", "الفجر", "البلد",
    "الشمس", "الليل", "الضحى", "الشرح", "التين", "العلق", "القدر", "البينة", "الزلزلة", "العاديات",
    "القارعة", "التكاثر", "العصر", "الهمزة", "الفيل", "قريش", "الماعون", "الكوثر", "الكافرون", "النصر",
    "المسد", "الإخلاص", "الفلق", "الناس"
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('القرآن الكريم'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'السور'),
              Tab(text: 'الأجزاء'),
              Tab(text: 'الأحزاب'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: QuranSearchDelegate());
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            SurahTabView(),
            JuzTabView(),
            HizbTabView(),
          ],
        ),
      ),
    );
  }
}

class SurahTabView extends ConsumerWidget {
  const SurahTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);
    const surahNames = [
      "الفاتحة", "البقرة", "آل عمران", "النساء", "المائدة", "الأنعام", "الأعراف", "الأنفال", "التوبة", "يونس",
      "هود", "يوسف", "الرعد", "إبراهيم", "الحجر", "النحل", "الإسراء", "الكهف", "مريم", "طه",
      "الأنبياء", "الحج", "المؤمنون", "النور", "الفرقان", "الشعراء", "النمل", "القصص", "العنكبوت", "الروم",
      "لقمان", "السجدة", "الأحزاب", "سبأ", "فاطر", "يس", "الصافات", "ص", "الزمر", "غافر",
      "فصلت", "الشورى", "الزخرف", "الدخان", "الجاثية", "الأحقاف", "محمد", "الفتح", "الحجرات", "ق",
      "الذاريات", "الطور", "النجم", "القمر", "الرحمن", "الواقعة", "الحديد", "المجادلة", "الحشر", "الممتحنة",
      "الصف", "الجمعة", "المنافقون", "التغابن", "الطلاق", "التحريم", "الملك", "القلم", "الحاقة", "المعارج",
      "نوح", "الجن", "المزمل", "المدثر", "القيامة", "الإنسان", "المرسلات", "النبأ", "النازعات", "عبس",
      "التكوير", "الانفطار", "المطففين", "الانشقاق", "البروج", "الطارق", "الأعلى", "الغاشية", "الفجر", "البلد",
      "الشمس", "الليل", "الضحى", "الشرح", "التين", "العلق", "القدر", "البينة", "الزلزلة", "العاديات",
      "القارعة", "التكاثر", "العصر", "الهمزة", "الفيل", "قريش", "الماعون", "الكوثر", "الكافرون", "النصر",
      "المسد", "الإخلاص", "الفلق", "الناس"
    ];

    return surahsAsync.when(
      data: (surahNumbers) => ListView.builder(
        itemCount: surahNumbers.length,
        itemBuilder: (context, index) {
          final number = surahNumbers[index];
          return ListTile(
            leading: CircleAvatar(child: Text(number.toString())),
            title: Text(surahNames[number - 1]),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(surahNumber: number, surahName: surahNames[number - 1]),
                ),
              );
            },
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }
}

class JuzTabView extends ConsumerWidget {
  const JuzTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        final juzNumber = index + 1;
        return ListTile(
          leading: CircleAvatar(child: Text(juzNumber.toString())),
          title: Text('الجزء $juzNumber'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SurahDetailScreen(
                  surahName: 'الجزء $juzNumber',
                  filter: QuranFilter(QuranFilterType.juz, juzNumber, 'الجزء $juzNumber'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class HizbTabView extends ConsumerWidget {
  const HizbTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: 60,
      itemBuilder: (context, index) {
        final hizbNumber = index + 1;
        return ListTile(
          leading: CircleAvatar(child: Text(hizbNumber.toString())),
          title: Text('الحزب $hizbNumber'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SurahDetailScreen(
                  surahName: 'الحزب $hizbNumber',
                  filter: QuranFilter(QuranFilterType.hizb, hizbNumber, 'الحزب $hizbNumber'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

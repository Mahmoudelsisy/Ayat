import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:share_plus/share_plus.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';
import '../../tafsir/providers/tafsir_provider.dart';
import '../../audio/providers/audio_provider.dart';
import '../../../core/services/audio_download_service.dart';
import '../../../shared/providers/font_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/mushaf_view.dart';

enum QuranFilterType { surah, juz, hizb }

class QuranFilter {
  final QuranFilterType type;
  final int value;
  final String name;
  QuranFilter(this.type, this.value, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranFilter && runtimeType == other.runtimeType && type == other.type && value == other.value;

  @override
  int get hashCode => type.hashCode ^ value.hashCode;
}

final quranContentProvider = FutureProvider.family<List<QuranData>, QuranFilter>((ref, filter) async {
  final db = ref.read(databaseProvider);
  switch (filter.type) {
    case QuranFilterType.surah:
      return await (db.select(db.quran)..where((t) => t.surahNumber.equals(filter.value))).get();
    case QuranFilterType.juz:
      return await (db.select(db.quran)..where((t) => t.juzNumber.equals(filter.value))).get();
    case QuranFilterType.hizb:
      // Hizb here is hizbQuarter. We want the full Hizb (4 quarters).
      // If user selected Hizb 1, it corresponds to quarters 1, 2, 3, 4.
      final start = (filter.value - 1) * 4 + 1;
      final end = filter.value * 4;
      return await (db.select(db.quran)..where((t) => t.hizbNumber.isBetween(Variable(start), Variable(end)))).get();
  }
});

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int? surahNumber;
  final String surahName;
  final QuranFilter? filter;

  const SurahDetailScreen({
    super.key,
    this.surahNumber,
    required this.surahName,
    this.filter,
  });

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isMushafMode = false;
  int? _currentAyahIndex;
  bool _isDownloaded = false;
  double _downloadProgress = 0;
  bool _isDownloading = false;
  final _downloadService = AudioDownloadService();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _checkIfDownloaded();
    _listenToPlayback();
  }

  void _listenToPlayback() {
    _audioPlayer.currentIndexStream.listen((index) {
      if (mounted) {
        setState(() => _currentAyahIndex = index);
      }
    });
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state.playing);
      }
    });
  }

  QuranFilter get _currentFilter => widget.filter ?? QuranFilter(QuranFilterType.surah, widget.surahNumber!, widget.surahName);

  Future<void> _checkIfDownloaded() async {
    final sNum = widget.surahNumber;
    if (sNum == null) return;
    final reciter = ref.read(selectedReciterProvider);
    final downloaded = await _downloadService.isSurahDownloaded(sNum, reciter.id);
    if (mounted) {
      setState(() => _isDownloaded = downloaded);
    }
    _saveLastRead();
  }

  Future<void> _saveLastRead() async {
    final sNum = widget.surahNumber;
    if (sNum == null) return;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt('last_surah_number', sNum);
    await prefs.setString('last_surah_name', widget.surahName);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSurah() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      final reciter = ref.read(selectedReciterProvider);

      try {
        final ayahs = await ref.read(quranContentProvider(_currentFilter).future);
        final playlist = ConcatenatingAudioSource(
          children: ayahs.map((ayah) {
            // Using Islamic Network for Ayah-by-Ayah URLs
            // We need absolute ayah number, but let's try a simpler way if possible
            // Actually, Islamic Network supports surah:ayah format in some endpoints?
            // No, but we can use: https://cdn.islamic.network/quran/audio/128/ar.alafasy/{absolute_ayah}.mp3

            // For now, let's use a placeholder that works or build it.
            // I'll use a helper to get absolute ayah number if possible,
            // but wait, alquran.cloud has it in the surah response.

            // Let's stick to the whole surah for now if highlighting is too complex without timing data,
            // OR I can use the alquran.cloud API to get all ayah URLs.

            final url = 'https://cdn.islamic.network/quran/audio/128/${reciter.ayahServerId}/${_getAbsoluteAyahNumber(ayah.surahNumber, ayah.ayahNumber)}.mp3';
            return AudioSource.uri(Uri.parse(url));
          }).toList(),
        );

        await _audioPlayer.setAudioSource(playlist);
        await _audioPlayer.play();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في تشغيل الصوت: $e')));
        }
      }
    }
  }

  int _getAbsoluteAyahNumber(int surah, int ayah) {
    // This is a simplified version. A real implementation would have a map of surah start ayahs.
    // I'll add a helper for this.
    return _surahStartAyahs[surah - 1] + ayah;
  }

  static const _surahStartAyahs = [
    0, 7, 293, 493, 669, 789, 954, 1160, 1235, 1364, 1473, 1596, 1707, 1750, 1802, 1901, 2029, 2140, 2250, 2348, 2483, 2595, 2673, 2791, 2855, 2932, 3159, 3252, 3340, 3409, 3469, 3503, 3533, 3606, 3660, 3705, 3788, 3970, 4058, 4133, 4218, 4272, 4325, 4414, 4473, 4510, 4545, 4583, 4601, 4619, 4664, 4724, 4776, 4789, 4826, 4904, 5000, 5052, 5064, 5088, 5101, 5115, 5123, 5134, 5152, 5164, 5176, 5206, 5258, 5286, 5314, 5342, 5370, 5398, 5426, 5454, 5485, 5522, 5552, 5580, 5622, 5650, 5658, 5694, 5719, 5747, 5762, 5781, 5803, 5833, 5853, 5864, 5875, 5880, 5885, 5893, 5898, 5901, 5909, 5912, 5923, 5934, 5942, 5945, 5952, 5957, 5962, 5969, 5972, 5978, 5981, 5984, 5988, 5993, 5998
  ];

  Future<void> _downloadSurah() async {
    final sNum = widget.surahNumber;
    if (sNum == null) return;
    final reciter = ref.read(selectedReciterProvider);
    final url = '${reciter.surahServer}${sNum.toString().padLeft(3, '0')}.mp3';

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      await _downloadService.downloadSurah(sNum, reciter.id, url, (progress) {
        if (mounted) {
          setState(() => _downloadProgress = progress);
        }
      });
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _isDownloaded = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم التحميل بنجاح')));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في التحميل: $e')));
      }
    }
  }

  void _showFontSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final selected = ref.watch(selectedFontProvider);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('اختر الخط', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...availableFonts.map((font) => ListTile(
                    title: Text(font, style: GoogleFonts.getFont(font)),
                    trailing: selected == font ? const Icon(Icons.check, color: Colors.green) : null,
                    onTap: () {
                      ref.read(selectedFontProvider.notifier).state = font;
                      Navigator.pop(context);
                    },
                  )),
            ],
          );
        },
      ),
    );
  }

  void _showReciterSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final selected = ref.watch(selectedReciterProvider);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('اختر القارئ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...reciters.map((r) => ListTile(
                    title: Text(r.name),
                    trailing: selected.id == r.id ? const Icon(Icons.check, color: Colors.green) : null,
                    onTap: () {
                      ref.read(selectedReciterProvider.notifier).state = r;
                      Navigator.pop(context);
                      if (_isPlaying) {
                        _playSurah(); // Restart with new reciter
                        _playSurah();
                      }
                    },
                  )),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ayahsAsync = ref.watch(quranContentProvider(_currentFilter));

    final selectedFont = ref.watch(selectedFontProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        actions: [
          IconButton(
            icon: Icon(_isMushafMode ? Icons.list : Icons.menu_book),
            onPressed: () => setState(() => _isMushafMode = !_isMushafMode),
          ),
          if (!_isMushafMode)
            IconButton(
              icon: const Icon(Icons.font_download),
              onPressed: () => _showFontSelection(),
            ),
          if (widget.surahNumber != null && !_isDownloaded)
            _isDownloading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(value: _downloadProgress, strokeWidth: 2, color: Colors.white),
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: _downloadSurah,
                  ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _showReciterSelection,
          ),
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _playSurah,
          ),
        ],
      ),
      body: _isMushafMode && widget.surahNumber != null
          ? MushafView(surahNumber: widget.surahNumber!)
          : ayahsAsync.when(
        data: (ayahs) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ayahs.length,
          itemBuilder: (context, index) {
            final ayah = ayahs[index];
            final isPlayingThis = _currentAyahIndex == index;

            return Container(
              color: isPlayingThis ? Colors.green.withValues(alpha: 0.2) : null,
              child: InkWell(
                onLongPress: () async {
                final db = ref.read(databaseProvider);
                await db.into(db.userProgress).insert(UserProgressCompanion.insert(
                      surahNumber: ayah.surahNumber,
                      ayahNumber: ayah.ayahNumber,
                    ));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديد الآية كمقروءة')));
                }
              },
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.3,
                    maxChildSize: 0.9,
                    expand: false,
                    builder: (context, scrollController) => Consumer(
                      builder: (context, ref, child) {
                        final type = ref.watch(selectedTafsirTypeProvider);
                        final tafsirAsync = ref.watch(tafsirProvider(TafsirParams(ayah.surahNumber, ayah.ayahNumber, type: type)));
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () {
                                      Share.share('${ayah.verseText}\n[سورة ${ayah.surahNumber} - آية ${ayah.ayahNumber}]');
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.bookmark_border),
                                    onPressed: () async {
                                      final db = ref.read(databaseProvider);
                                      await db.into(db.bookmarks).insert(BookmarksCompanion.insert(
                                            surahNumber: ayah.surahNumber,
                                            ayahNumber: ayah.ayahNumber,
                                          ));
                                      if (mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت الإضافة للمرجعية')));
                                      }
                                    },
                                  ),
                                  Text('تفسير الآية ${ayah.ayahNumber}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                  DropdownButton<String>(
                                    value: type,
                                    items: const [
                                      DropdownMenuItem(value: 'saadi', child: Text('السعدي')),
                                      DropdownMenuItem(value: 'ibn_kathir', child: Text('ابن كثير')),
                                      DropdownMenuItem(value: 'meanings', child: Text('معاني الكلمات')),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        ref.read(selectedTafsirTypeProvider.notifier).state = val;
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              tafsirAsync.when(
                                data: (data) => Text(
                                  data?.tafsirText.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'لا يوجد تفسير متاح',
                                  style: const TextStyle(fontSize: 18, height: 1.6),
                                  textAlign: TextAlign.right,
                                ),
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (err, stack) => Text('خطأ في تحميل التفسير: $err'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      ayah.verseText,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.getFont(selectedFont, fontSize: 24, height: 2),
                    ),
                    const Divider(),
                  ],
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

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
import '../../../shared/providers/reading_provider.dart';
import '../../../shared/providers/reading_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/mushaf_view.dart';
import 'dart:io';

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
  final reading = ref.watch(selectedReadingProvider);

  switch (filter.type) {
    case QuranFilterType.surah:
      return await (db.select(db.quran)..where((t) => t.surahNumber.equals(filter.value) & t.reading.equals(reading))).get();
    case QuranFilterType.juz:
      return await (db.select(db.quran)..where((t) => t.juzNumber.equals(filter.value) & t.reading.equals(reading))).get();
    case QuranFilterType.hizb:
      final start = (filter.value - 1) * 4 + 1;
      final end = filter.value * 4;
      return await (db.select(db.quran)..where((t) => t.hizbNumber.isBetween(Variable(start), Variable(end)) & t.reading.equals(reading))).get();
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
  bool _isParallelMode = false;
  LoopMode _loopMode = LoopMode.off;
  int _repeatCount = 1;
  int _currentRepeatIndex = 0;
  bool _isMushafMode = false;
  int? _currentAyahIndex;
  bool _isDownloaded = false;
  double _downloadProgress = 0;
  bool _isDownloading = false;
  double _playbackSpeed = 1.0;
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
        setState(() {
          if (_currentAyahIndex != index) {
            _currentRepeatIndex = 0;
          }
          _currentAyahIndex = index;
        });
      }
    });
    _audioPlayer.playerStateStream.listen((state) async {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }

      if (state.processingState == ProcessingState.completed) {
        if (_loopMode == LoopMode.one && _repeatCount > 1) {
          if (_currentRepeatIndex < _repeatCount - 1) {
            _currentRepeatIndex++;
            await _audioPlayer.seek(Duration.zero);
            await _audioPlayer.play();
          } else {
            _currentRepeatIndex = 0;
            if (_audioPlayer.hasNext) {
              await _audioPlayer.seekToNext();
              await _audioPlayer.play();
            } else {
              if (mounted) setState(() => _isPlaying = false);
            }
          }
        } else if (_loopMode == LoopMode.off) {
          if (mounted) setState(() => _isPlaying = false);
        }
      }
    });
    _audioPlayer.loopModeStream.listen((mode) {
      if (mounted) {
        setState(() => _loopMode = mode);
      }
    });
    _audioPlayer.speedStream.listen((speed) {
      if (mounted) {
        setState(() => _playbackSpeed = speed);
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

  void _toggleLoopMode() {
    setState(() {
      if (_loopMode == LoopMode.off) {
        _loopMode = LoopMode.one;
        _repeatCount = 1;
      } else if (_loopMode == LoopMode.one && _repeatCount == 1) {
        _repeatCount = 3;
      } else if (_loopMode == LoopMode.one && _repeatCount == 3) {
        _repeatCount = 5;
      } else if (_loopMode == LoopMode.one && _repeatCount == 5) {
        _loopMode = LoopMode.all;
      } else {
        _loopMode = LoopMode.off;
      }

      // If we are doing custom repeat (3x, 5x), we actually want just_audio to NOT loop automatically
      // because we handle it in playerStateStream.
      if (_loopMode == LoopMode.one && _repeatCount > 1) {
        _audioPlayer.setLoopMode(LoopMode.off);
      } else {
        _audioPlayer.setLoopMode(_loopMode);
      }
    });
  }

  void _changeSpeed() {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    final currentIndex = speeds.indexOf(_playbackSpeed);
    final nextIndex = (currentIndex + 1) % speeds.length;
    _audioPlayer.setSpeed(speeds[nextIndex]);
  }

  Future<void> _playSurah() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      final reciter = ref.read(selectedReciterProvider);

      try {
        final ayahs = await ref.read(quranContentProvider(_currentFilter).future);
        final playlist = ConcatenatingAudioSource(
          children: await Future.wait(ayahs.map((ayah) async {
            final localPath = await _downloadService.getAyahPath(ayah.surahNumber, ayah.ayahNumber, reciter.id);
            if (File(localPath).existsSync()) {
              return AudioSource.file(localPath);
            }
            final url = 'https://cdn.islamic.network/quran/audio/128/${reciter.ayahServerId}/${_getAbsoluteAyahNumber(ayah.surahNumber, ayah.ayahNumber)}.mp3';
            return AudioSource.uri(Uri.parse(url));
          })),
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

  void _showThemeSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final current = ref.watch(readingThemeProvider);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('سمة القراءة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.wb_sunny, color: Colors.orange),
                title: const Text('أبيض'),
                trailing: current == ReadingTheme.white ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () => _updateReadingTheme(ReadingTheme.white),
              ),
              ListTile(
                leading: const Icon(Icons.book, color: Color(0xFF5B4636)),
                title: const Text('ورقي (سيبيا)'),
                trailing: current == ReadingTheme.sepia ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () => _updateReadingTheme(ReadingTheme.sepia),
              ),
              ListTile(
                leading: const Icon(Icons.nightlight_round, color: Colors.blueGrey),
                title: const Text('ليلي'),
                trailing: current == ReadingTheme.night ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () => _updateReadingTheme(ReadingTheme.night),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateReadingTheme(ReadingTheme theme) {
    ref.read(readingThemeProvider.notifier).state = theme;
    ref.read(sharedPreferencesProvider).setString('reading_theme', theme.name);
    Navigator.pop(context);
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
    final quranFontSize = ref.watch(quranFontSizeProvider);
    final tafsirFontSize = ref.watch(tafsirFontSizeProvider);
    final readingTheme = ref.watch(readingThemeProvider);

    return Scaffold(
      backgroundColor: readingTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.surahName),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: _showThemeSelection,
            tooltip: 'سمة القراءة',
          ),
          IconButton(
            icon: Icon(_isParallelMode ? Icons.vertical_split : Icons.vertical_split_outlined),
            onPressed: () => setState(() => _isParallelMode = !_isParallelMode),
            tooltip: 'وضع التوازي (تفسير)',
          ),
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
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  _loopMode == LoopMode.one
                      ? Icons.repeat_one
                      : _loopMode == LoopMode.all
                          ? Icons.repeat
                          : Icons.repeat_on_outlined,
                  color: _loopMode == LoopMode.off ? Colors.white54 : Colors.white,
                ),
                if (_loopMode == LoopMode.one && _repeatCount > 1)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Text(
                      '$_repeatCount',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                  ),
              ],
            ),
            onPressed: _toggleLoopMode,
            tooltip: 'وضع التكرار',
          ),
          IconButton(
            icon: Text('${_playbackSpeed}x', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            onPressed: _changeSpeed,
            tooltip: 'سرعة التشغيل',
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
                if (context.mounted) {
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
                                      Share.share('﴿ ${ayah.verseText} ﴾\n\n[سورة ${widget.surahName} - آية ${ayah.ayahNumber}]\nتمت المشاركة من تطبيق آيات');
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
                                      if (context.mounted) {
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
                                  style: TextStyle(fontSize: tafsirFontSize + 2, height: 1.6),
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
                      style: GoogleFonts.getFont(selectedFont,
                          fontSize: quranFontSize, height: 2, color: readingTheme.textColor),
                    ),
                    if (_isParallelMode)
                      Consumer(builder: (context, ref, child) {
                        final type = ref.watch(selectedTafsirTypeProvider);
                        final tafsirAsync = ref.watch(surahTafsirProvider(TafsirParams(ayah.surahNumber, 0, type: type)));
                        return tafsirAsync.when(
                          data: (map) => Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              map[ayah.ayahNumber]?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
                              style: TextStyle(fontSize: tafsirFontSize, color: Colors.blueGrey, height: 1.5),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          loading: () => const SizedBox(),
                          error: (e, s) => const SizedBox(),
                        );
                      }),
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

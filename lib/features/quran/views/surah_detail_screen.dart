import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';
import '../../tafsir/providers/tafsir_provider.dart';
import '../../audio/providers/audio_provider.dart';

final surahContentProvider = FutureProvider.family<List<QuranData>, int>((ref, surahNumber) async {
  final db = ref.read(databaseProvider);
  return await (db.select(db.quran)..where((t) => t.surahNumber.equals(surahNumber))).get();
});

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailScreen({super.key, required this.surahNumber, required this.surahName});

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSurah() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      final reciter = ref.read(selectedReciterProvider);
      final url = '${reciter.server}${widget.surahNumber.toString().padLeft(3, '0')}.mp3';
      try {
        await _audioPlayer.setUrl(url);
        await _audioPlayer.play();
        setState(() => _isPlaying = true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في تشغيل الصوت: $e')));
        }
      }
    }
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
    final ayahsAsync = ref.watch(surahContentProvider(widget.surahNumber));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        actions: [
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
      body: ayahsAsync.when(
        data: (ayahs) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ayahs.length,
          itemBuilder: (context, index) {
            final ayah = ayahs[index];
            return InkWell(
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
                        final tafsirAsync = ref.watch(tafsirProvider(TafsirParams(ayah.surahNumber, ayah.ayahNumber)));
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Text('تفسير الآية ${ayah.ayahNumber}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                      style: const TextStyle(fontSize: 22, height: 2, fontFamily: 'Cairo'),
                    ),
                    const Divider(),
                  ],
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

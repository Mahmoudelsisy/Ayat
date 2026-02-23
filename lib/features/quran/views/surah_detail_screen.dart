import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';

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
      final url = 'https://download.quranicaudio.com/quran/mishari_rashid_al-afasy/${widget.surahNumber.toString().padLeft(3, '0')}.mp3';
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ayahsAsync = ref.watch(surahContentProvider(widget.surahNumber));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        actions: [
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
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('تفسير الآية ${ayah.ayahNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 10),
                        const Text('التفسير الميسر: جاري العمل على توفير كافة التفاسير...'),
                      ],
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

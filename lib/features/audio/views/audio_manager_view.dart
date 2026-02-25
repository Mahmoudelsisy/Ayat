import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../providers/audio_provider.dart';

class AudioManagerView extends ConsumerStatefulWidget {
  const AudioManagerView({super.key});

  @override
  ConsumerState<AudioManagerView> createState() => _AudioManagerViewState();
}

class _AudioManagerViewState extends ConsumerState<AudioManagerView> {
  List<FileSystemEntity> _downloadedSurahs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    setState(() => _isLoading = true);
    final directory = await getApplicationDocumentsDirectory();
    final audioRoot = Directory(p.join(directory.path, 'audio'));

    List<FileSystemEntity> files = [];
    if (await audioRoot.exists()) {
      final recitersDirs = audioRoot.listSync();
      for (var reciterDir in recitersDirs) {
        if (reciterDir is Directory) {
          final surahsDir = Directory(p.join(reciterDir.path, 'surahs'));
          if (await surahsDir.exists()) {
            files.addAll(surahsDir.listSync());
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _downloadedSurahs = files;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteSurah(FileSystemEntity file) async {
    await file.delete();
    _loadDownloads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مدير التحميلات الصوتية')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _downloadedSurahs.isEmpty
              ? const Center(child: Text('لا توجد تحميلات صوتية بعد'))
              : ListView.builder(
                  itemCount: _downloadedSurahs.length,
                  itemBuilder: (context, index) {
                    final file = _downloadedSurahs[index];
                    final fileName = p.basename(file.path);
                    final reciterId = p.basename(file.parent.parent.path);
                    final reciterName = reciters.firstWhere((r) => r.id == reciterId, orElse: () => reciters[0]).name;

                    return ListTile(
                      leading: const Icon(Icons.audio_file, color: Colors.green),
                      title: Text('سورة ${int.tryParse(fileName.replaceAll('.mp3', '')) ?? fileName}'),
                      subtitle: Text('القارئ: $reciterName'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteSurah(file),
                      ),
                    );
                  },
                ),
    );
  }
}

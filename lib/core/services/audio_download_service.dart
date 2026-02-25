import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AudioDownloadService {
  Future<String> getSurahPath(int surahNumber, String reciterId) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, 'audio', reciterId, 'surahs');
    await Directory(path).create(recursive: true);
    return p.join(path, '${surahNumber.toString().padLeft(3, '0')}.mp3');
  }

  Future<String> getAyahPath(int surahNumber, int ayahNumber, String reciterId) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, 'audio', reciterId, 'ayahs', surahNumber.toString());
    await Directory(path).create(recursive: true);
    return p.join(path, '${ayahNumber.toString().padLeft(3, '0')}.mp3');
  }

  Future<bool> isSurahDownloaded(int surahNumber, String reciterId) async {
    final path = await getSurahPath(surahNumber, reciterId);
    return File(path).exists();
  }

  Future<bool> isAyahDownloaded(int surahNumber, int ayahNumber, String reciterId) async {
    final path = await getAyahPath(surahNumber, ayahNumber, reciterId);
    return File(path).exists();
  }

  Future<void> downloadSurah(int surahNumber, String reciterId, String url, Function(double) onProgress) async {
    final path = await getSurahPath(surahNumber, reciterId);
    final file = File(path);

    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);

      final contentLength = response.contentLength ?? 0;
      var downloadedLength = 0;

      final bytes = <int>[];
      await response.stream.forEach((chunk) {
        bytes.addAll(chunk);
        downloadedLength += chunk.length;
        if (contentLength > 0) {
          onProgress(downloadedLength / contentLength);
        }
      });

      await file.writeAsBytes(bytes);
    } finally {
      client.close();
    }
  }
}

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class MushafDownloadService {
  Future<String> getImagePath(int pageNumber) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, 'mushaf');
    await Directory(path).create(recursive: true);
    return p.join(path, '$pageNumber.png');
  }

  Future<bool> isPageDownloaded(int pageNumber) async {
    final path = await getImagePath(pageNumber);
    return File(path).exists();
  }

  Future<bool> isMushafDownloaded() async {
    // Check if a sample of pages exists
    return await isPageDownloaded(1) && await isPageDownloaded(604);
  }

  Future<void> downloadPage(int pageNumber) async {
    final path = await getImagePath(pageNumber);
    final file = File(path);
    if (await file.exists()) return;

    final url = 'https://raw.githubusercontent.com/m4hmoud-atef/Islamic-and-quran-data/main/quran_images/quran_images_1/$pageNumber.png';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
    }
  }

  Future<void> downloadAllPages(Function(double) onProgress) async {
    for (int i = 1; i <= 604; i++) {
      await downloadPage(i);
      onProgress(i / 604);
    }
  }
}

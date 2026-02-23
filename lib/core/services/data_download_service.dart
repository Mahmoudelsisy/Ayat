import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/database.dart';
import 'package:drift/drift.dart';

class DataDownloadService {
  final AppDatabase db;

  DataDownloadService(this.db);

  Future<void> downloadAllData(Function(double) onProgress) async {
    await downloadQuran(onProgress);
    await downloadAzkar(onProgress);
  }

  Future<void> downloadQuran(Function(double) onProgress) async {
    // Check if data already exists
    final count = await (db.select(db.quran)..limit(1)).get();
    if (count.isNotEmpty) return;

    final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/quran/quran-uthmani'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final surahs = data['data']['surahs'] as List;

      for (var i = 0; i < surahs.length; i++) {
        final surah = surahs[i];
        final ayahs = surah['ayahs'] as List;
        final surahNumber = surah['number'] as int;

        await db.batch((batch) {
          batch.insertAll(db.quran, [
            for (var ayah in ayahs)
              QuranCompanion.insert(
                surahNumber: surahNumber,
                ayahNumber: ayah['numberInSurah'] as int,
                verseText: ayah['text'] as String,
              )
          ]);
        });
        onProgress((i + 1) / surahs.length * 0.7); // Quran is 70% of total
      }
    }
  }

  Future<void> downloadAzkar(Function(double) onProgress) async {
    final count = await (db.select(db.azkar)..limit(1)).get();
    if (count.isNotEmpty) return;

    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/m4hmoud-atef/Islamic-and-quran-data/main/azkar/azkar.json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;

      for (var i = 0; i < data.length; i++) {
        final category = data[i]['category'] as String;
        final items = data[i]['array'] as List;

        await db.batch((batch) {
          batch.insertAll(db.azkar, [
            for (var item in items)
              AzkarCompanion.insert(
                category: category,
                zikrText: item['text'] as String,
                count: Value(int.tryParse(item['count'].toString()) ?? 1),
              )
          ]);
        });
        onProgress(0.7 + ((i + 1) / data.length * 0.3)); // Azkar is 30%
      }
    }
  }
}

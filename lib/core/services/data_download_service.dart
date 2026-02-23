import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/database.dart';
import 'package:drift/drift.dart';

class DataDownloadService {
  final AppDatabase db;

  DataDownloadService(this.db);

  Future<void> downloadAllData(Function(double) onProgress) async {
    await downloadQuran(onProgress);
    await downloadTafsir("al_sa'dy.json", 'saadi', (p) => onProgress(0.7 + (p * 0.1)));
    await downloadTafsir("ebn_katheer.json", 'ibn_kathir', (p) => onProgress(0.8 + (p * 0.1)));
    await downloadAzkar((p) => onProgress(0.9 + (p * 0.05)));
    await downloadAllahNames((p) => onProgress(0.95 + (p * 0.05)));
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
                juzNumber: Value(ayah['juz'] as int),
                hizbNumber: Value(ayah['hizbQuarter'] as int),
                verseText: ayah['text'] as String,
              )
          ]);
        });
        onProgress((i + 1) / surahs.length * 0.7); // Quran is 70% of total
      }
    }
  }

  Future<void> downloadTafsir(String fileName, String type, Function(double) onProgress) async {
    final count = await (db.select(db.tafsirs)..where((t) => t.type.equals(type))..limit(1)).get();
    if (count.isNotEmpty) return;

    final response = await http.get(Uri.parse("https://raw.githubusercontent.com/m4hmoud-atef/Islamic-and-quran-data/main/tafseer/$fileName"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      const batchSize = 100;
      for (var i = 0; i < data.length; i += batchSize) {
        final end = (i + batchSize < data.length) ? i + batchSize : data.length;
        final batchData = data.sublist(i, end);

        await db.batch((batch) {
          batch.insertAll(db.tafsirs, [
            for (var item in batchData)
              TafsirsCompanion.insert(
                surahNumber: item['sura'] as int,
                ayahNumber: item['aya'] as int,
                tafsirText: item['text'] as String,
                type: type,
              )
          ]);
        });
        onProgress(end / data.length);
      }
    }
  }

  Future<void> downloadAllahNames(Function(double) onProgress) async {
    final count = await (db.select(db.allahNames)..limit(1)).get();
    if (count.isNotEmpty) return;

    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/m4hmoud-atef/Islamic-and-quran-data/main/99_allah_names/allah_names_ar.json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      await db.batch((batch) {
        batch.insertAll(db.allahNames, [
          for (var item in data)
            AllahNamesCompanion.insert(
              name: item['name'] as String,
              meaning: item['text'] as String,
            )
        ]);
      });
      onProgress(1.0);
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
        onProgress((i + 1) / data.length);
      }
    }
  }
}

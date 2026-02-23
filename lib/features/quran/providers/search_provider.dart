import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';
import 'package:drift/drift.dart';

final quranSearchProvider = FutureProvider.family<List<QuranData>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final db = ref.read(databaseProvider);
  return await (db.select(db.quran)..where((t) => t.verseText.contains(query))).get();
});

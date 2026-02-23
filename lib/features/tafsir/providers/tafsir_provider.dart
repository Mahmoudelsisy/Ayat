import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';
import 'package:drift/drift.dart';

class TafsirParams {
  final int surahNumber;
  final int ayahNumber;
  TafsirParams(this.surahNumber, this.ayahNumber);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TafsirParams &&
          runtimeType == other.runtimeType &&
          surahNumber == other.surahNumber &&
          ayahNumber == other.ayahNumber;

  @override
  int get hashCode => surahNumber.hashCode ^ ayahNumber.hashCode;
}

final tafsirProvider = FutureProvider.family<Tafsir?, TafsirParams>((ref, params) async {
  final db = ref.read(databaseProvider);
  return await (db.select(db.tafsirs)
        ..where((t) => t.surahNumber.equals(params.surahNumber) & t.ayahNumber.equals(params.ayahNumber)))
      .getSingleOrNull();
});

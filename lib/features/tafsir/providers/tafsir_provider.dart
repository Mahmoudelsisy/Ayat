import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';
import 'package:drift/drift.dart';

class TafsirParams {
  final int surahNumber;
  final int ayahNumber;
  final String type;
  TafsirParams(this.surahNumber, this.ayahNumber, {this.type = 'saadi'});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TafsirParams &&
          runtimeType == other.runtimeType &&
          surahNumber == other.surahNumber &&
          ayahNumber == other.ayahNumber &&
          type == other.type;

  @override
  int get hashCode => surahNumber.hashCode ^ ayahNumber.hashCode ^ type.hashCode;
}

final selectedTafsirTypeProvider = StateProvider<String>((ref) => 'saadi');

final tafsirProvider = FutureProvider.family<Tafsir?, TafsirParams>((ref, params) async {
  final db = ref.read(databaseProvider);
  return await (db.select(db.tafsirs)
        ..where((t) =>
            t.surahNumber.equals(params.surahNumber) &
            t.ayahNumber.equals(params.ayahNumber) &
            t.type.equals(params.type)))
      .getSingleOrNull();
});

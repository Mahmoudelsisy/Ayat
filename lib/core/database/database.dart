import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

class Quran extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  IntColumn get juzNumber => integer().nullable()();
  IntColumn get hizbNumber => integer().nullable()();
  IntColumn get pageNumber => integer().nullable()();
  TextColumn get verseText => text()();
  TextColumn get translation => text().nullable()();
  TextColumn get reading => text().withDefault(const Constant('hafs'))();
}

class Tafsirs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  TextColumn get tafsirText => text()();
  TextColumn get type => text()(); // e.g., 'ibn_kathir', 'saadi'
}

class Azkar extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  TextColumn get zikrText => text()();
  TextColumn get reference => text().nullable()();
  IntColumn get count => integer().withDefault(const Constant(1))();
}

class UserProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

class AllahNames extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get meaning => text()();
}

class KhatmaPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get startDate => dateTime()();
  IntColumn get targetDays => integer()();
  IntColumn get progressAyahs => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [Quran, Tafsirs, Azkar, UserProgress, Bookmarks, AllahNames, KhatmaPlans])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    final cachebase = await getTemporaryDirectory();
    sqlite3.tempDirectory = cachebase.path;

    return NativeDatabase.createInBackground(
      file,
      setup: (db) {
        // In a real app, use a key from Secure Storage
        // db.execute("PRAGMA key = 'my_secure_key'");
      },
    );
  });
}

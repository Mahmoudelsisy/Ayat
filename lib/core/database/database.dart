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

class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get icon => text()();
  DateTimeColumn get dateEarned => dateTime().withDefault(currentDateAndTime)();
}

class FastingTracking extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get hYear => integer()();
  IntColumn get hMonth => integer()();
  IntColumn get hDay => integer()();
  TextColumn get type => text()(); // e.g., 'Ramadan', 'Sunnah', 'Qada'
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

class CalendarNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get hYear => integer()();
  IntColumn get hMonth => integer()();
  IntColumn get hDay => integer()();
  TextColumn get note => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

class DailyCommitment extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get prayerCount => integer().withDefault(const Constant(0))();
  BoolColumn get morningAzkar => boolean().withDefault(const Constant(false))();
  BoolColumn get eveningAzkar => boolean().withDefault(const Constant(false))();
  TextColumn get jamaahPrayers => text().nullable()(); // Comma separated IDs or JSON
  TextColumn get sunnahPrayers => text().nullable()(); // Comma separated IDs or JSON
}

@DriftDatabase(tables: [
  Quran,
  Tafsirs,
  Azkar,
  UserProgress,
  Bookmarks,
  AllahNames,
  KhatmaPlans,
  Achievements,
  FastingTracking,
  CalendarNotes,
  DailyCommitment
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(fastingTracking);
            await m.createTable(calendarNotes);
          }
          if (from < 3) {
            await m.createTable(dailyCommitment);
          }
          if (from < 4) {
            await m.addColumn(dailyCommitment, dailyCommitment.jamaahPrayers);
            await m.addColumn(dailyCommitment, dailyCommitment.sunnahPrayers);
          }
        },
      );
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

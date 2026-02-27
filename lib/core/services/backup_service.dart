import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../database/database.dart';

class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  Future<void> exportBackup() async {
    final bookmarks = await db.select(db.bookmarks).get();
    final progress = await db.select(db.userProgress).get();
    final plans = await db.select(db.khatmaPlans).get();
    final commitments = await db.select(db.dailyCommitment).get();
    final fasting = await db.select(db.fastingTracking).get();
    final notes = await db.select(db.calendarNotes).get();

    final data = {
      'bookmarks': bookmarks.map((e) => e.toJson()).toList(),
      'progress': progress.map((e) => e.toJson()).toList(),
      'plans': plans.map((e) => e.toJson()).toList(),
      'commitments': commitments.map((e) => e.toJson()).toList(),
      'fasting': fasting.map((e) => e.toJson()).toList(),
      'notes': notes.map((e) => e.toJson()).toList(),
    };

    final jsonStr = jsonEncode(data);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/ayat_backup.json');
    await file.writeAsString(jsonStr);

    await Share.shareXFiles([XFile(file.path)], text: 'Ayat App Backup');
  }

  Future<bool> importBackup(String jsonStr) async {
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      await db.transaction(() async {
        // Clear existing data
        await db.delete(db.bookmarks).go();
        await db.delete(db.userProgress).go();
        await db.delete(db.khatmaPlans).go();
        await db.delete(db.dailyCommitment).go();
        await db.delete(db.fastingTracking).go();
        await db.delete(db.calendarNotes).go();

        // Import new data
        if (data['bookmarks'] != null) {
          for (var item in data['bookmarks']) {
            await db.into(db.bookmarks).insert(Bookmark.fromJson(item));
          }
        }
        if (data['progress'] != null) {
          for (var item in data['progress']) {
            await db.into(db.userProgress).insert(UserProgressData.fromJson(item));
          }
        }
        if (data['plans'] != null) {
          for (var item in data['plans']) {
            await db.into(db.khatmaPlans).insert(KhatmaPlan.fromJson(item));
          }
        }
        if (data['commitments'] != null) {
          for (var item in data['commitments']) {
            await db.into(db.dailyCommitment).insert(DailyCommitmentData.fromJson(item));
          }
        }
        if (data['fasting'] != null) {
          for (var item in data['fasting']) {
            await db.into(db.fastingTracking).insert(FastingTrackingData.fromJson(item));
          }
        }
        if (data['notes'] != null) {
          for (var item in data['notes']) {
            await db.into(db.calendarNotes).insert(CalendarNote.fromJson(item));
          }
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}

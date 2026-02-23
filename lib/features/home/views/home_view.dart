import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/database.dart';
import 'package:drift/drift.dart' as drift hide Column;
import 'package:hijri/hijri_calendar.dart';
import '../../quran/views/surah_detail_screen.dart';
import '../../prayer_times/providers/prayer_times_provider.dart';
import '../../modes/views/modes_screen.dart';
import '../../bookmarks/views/bookmarks_screen.dart';
import '../../stats/views/stats_screen.dart';
import '../../calendar/views/calendar_screen.dart';
import '../../prayer_times/views/travel_mode_screen.dart';
import '../../audio/views/audio_comparison_screen.dart';
import 'allah_names_screen.dart';
import 'khatma_planner_screen.dart';
import '../../stats/views/achievements_screen.dart';
import '../../modes/views/ramadan_view.dart';

final readAyahsCountProvider = FutureProvider<int>((ref) async {
  final db = ref.read(databaseProvider);
  final countExp = db.userProgress.id.count();
  final query = db.selectOnly(db.userProgress)..addColumns([countExp]);
  final result = await query.getSingle();
  return (result.read(countExp) ?? 0).toInt();
});

final randomDuaProvider = FutureProvider<AzkarData?>((ref) async {
  final db = ref.read(databaseProvider);
  final query = db.select(db.azkar)..orderBy([(t) => drift.OrderingTerm.random()])..limit(1);
  return await query.getSingleOrNull();
});

final dailyVerseProvider = FutureProvider<QuranData?>((ref) async {
  final db = ref.read(databaseProvider);
  const count = 6236;
  final randomId = DateTime.now().day * 100 % count + 1;
  final query = db.select(db.quran)..where((t) => t.id.equals(randomId))..limit(1);
  return await query.getSingleOrNull();
});

final todayCommitmentProvider = FutureProvider<DailyCommitmentData?>((ref) async {
  final db = ref.read(databaseProvider);
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return await (db.select(db.dailyCommitment)..where((t) => t.date.isBetweenValues(startOfDay, endOfDay))).getSingleOrNull();
});

final spiritualTipProvider = Provider<String>((ref) {
  final tips = [
    "ابدأ يومك بذكْر الله لتنعم بالبركة في وقتك.",
    "ركعة في جوف الليل خير من الدنيا وما فيها.",
    "حافظ على وردك القرآني ولو كان صفحة واحدة يومياً.",
    "الصدقة تطفئ غضب الرب وتدفع ميتة السوء.",
    "جدد توبتك مع كل أذان، فالمؤمن تواب.",
    "صلة الرحم تزيد في الرزق وتطيل في العمر.",
    "أكثر من الصلاة على النبي صلى الله عليه وسلم يوم الجمعة.",
    "بر الوالدين مفتاحك إلى الجنة.",
    "الكلمة الطيبة صدقة.",
    "اجعل لك خبيئة من عمل صالح لا يعلمها إلا الله.",
  ];
  return tips[DateTime.now().day % tips.length];
});

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  String _nextPrayerName = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    _checkAchievements();
  }

  Future<void> _checkAchievements() async {
    final db = ref.read(databaseProvider);
    final count = await ref.read(readAyahsCountProvider.future);

    if (count >= 100) {
      final existing = await (db.select(db.achievements)..where((t) => t.title.equals('قارئ مجتهد'))).get();
      if (existing.isEmpty) {
        await db.into(db.achievements).insert(AchievementsCompanion.insert(
          title: 'قارئ مجتهد',
          description: 'قرأت أكثر من 100 آية',
          icon: 'star',
        ));
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateCountdown();
    });
  }

  void _calculateCountdown() {
    final prayerTimesAsync = ref.read(prayerTimesProvider);
    prayerTimesAsync.whenData((times) {
      final now = DateTime.now();
      final next = times.nextPrayer();

      final nextTime = times.timeForPrayer(next);
      if (nextTime != null) {
        if (mounted) {
          setState(() {
            _timeLeft = nextTime.difference(now);
            _nextPrayerName = _getPrayerNameArabic(next);
          });
        }
      }
    });
  }

  String _getPrayerNameArabic(dynamic prayer) {
    // Adhan package uses enum
    switch (prayer.toString()) {
      case 'Prayer.fajr': return 'الفجر';
      case 'Prayer.dhuhr': return 'الظهر';
      case 'Prayer.asr': return 'العصر';
      case 'Prayer.maghrib': return 'المغرب';
      case 'Prayer.isha': return 'العشاء';
      default: return 'الصلاة القادمة';
    }
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final readCountAsync = ref.watch(readAyahsCountProvider);
    const totalAyahs = 6236;

    final prefs = ref.watch(sharedPreferencesProvider);
    final lastSurahNum = prefs.getInt('last_surah_number');
    final lastSurahName = prefs.getString('last_surah_name');

    return Scaffold(
      appBar: AppBar(
        title: const Text('آيات', style: TextStyle(fontFamily: 'Reem Kufi', fontSize: 28)),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_nextPrayerName.isNotEmpty) _buildCountdownCard(),
          const SizedBox(height: 20),
          if (lastSurahNum != null) ...[
            _buildLastReadCard(context, lastSurahNum, lastSurahName!),
            const SizedBox(height: 20),
          ],
          _buildDailyVerse(ref),
          const SizedBox(height: 10),
          _buildSpiritualTip(ref),
          const SizedBox(height: 20),
          _buildDuaOfDay(ref),
          const SizedBox(height: 20),
          _buildSpiritualChecklist(),
          const SizedBox(height: 20),
          _buildCommitmentStats(),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('تقدم الختمة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  readCountAsync.when(
                    data: (count) {
                      final progress = count / totalAyahs;
                      return Column(
                        children: [
                          LinearProgressIndicator(value: progress, minHeight: 10),
                          const SizedBox(height: 10),
                          Text('تمت قراءة $count من $totalAyahs آية (${(progress * 100).toStringAsFixed(1)}%)'),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (err, stack) => Text('خطأ: $err'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildRamadanCountdown(),
          const SizedBox(height: 20),
          _buildQuickAction(context, 'وضع رمضان (إفطار، ختمة، أذكار)', Icons.star, Colors.indigo, destination: const RamadanView()),
          _buildQuickAction(context, 'الإحصائيات والتقدم', Icons.bar_chart, Colors.blue, destination: const StatsScreen()),
          _buildQuickAction(context, 'وضع السفر (قصر الصلاة)', Icons.flight_takeoff, Colors.blueAccent, destination: const TravelModeScreen()),
          _buildQuickAction(context, 'التقويم الهجري والمناسبات', Icons.calendar_today, Colors.teal, destination: const CalendarScreen()),
          _buildQuickAction(context, 'مقارنة القراء', Icons.compare, Colors.brown, destination: const AudioComparisonScreen()),
          _buildQuickAction(context, 'أسماء الله الحسنى', Icons.auto_awesome, Colors.amber, destination: const AllahNamesScreen()),
          _buildQuickAction(context, 'مخطط الختمة', Icons.edit_calendar, Colors.deepOrange, destination: const KhatmaPlannerScreen()),
          _buildQuickAction(context, 'قائمة الإنجازات', Icons.emoji_events, Colors.amber, destination: const AchievementsScreen()),
          _buildQuickAction(context, 'المرجعيات', Icons.bookmark, Colors.red, destination: const BookmarksScreen()),
          _buildQuickAction(context, 'الأوضاع الخاصة (قيام، خلوة)', Icons.brightness_4, Colors.purple, destination: const ModesScreen()),
          _buildQuickAction(context, 'أذكار الصباح', Icons.wb_sunny, Colors.orange),
          _buildQuickAction(context, 'أذكار المساء', Icons.nightlight_round, Colors.indigo),
          _buildQuickAction(context, 'سورة الكهف', Icons.menu_book, Colors.green),
        ],
      ),
      ),
    );
  }

  Widget _buildRamadanCountdown() {
    final hijriNow = HijriCalendar.now();
    int daysToRamadan;

    if (hijriNow.hMonth < 9) {
      // Ramadan is month 9
      // Simplistic calculation: assume 30 days per month
      daysToRamadan = (9 - hijriNow.hMonth - 1) * 30 + (30 - hijriNow.hDay);
    } else if (hijriNow.hMonth == 9) {
      daysToRamadan = 0; // It is Ramadan!
    } else {
      daysToRamadan = (12 - hijriNow.hMonth + 8) * 30 + (30 - hijriNow.hDay);
    }

    return Card(
      color: Colors.green[100],
      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.orange),
        title: Text(daysToRamadan == 0 ? 'رمضان مبارك!' : 'باقي على رمضان $daysToRamadan يوم'),
        subtitle: const Text('اللهم بلغنا رمضان'),
      ),
    );
  }

  Widget _buildCommitmentStats() {
    final commitmentAsync = ref.watch(todayCommitmentProvider);

    return Card(
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('مؤشرات الالتزام اليومي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            commitmentAsync.when(
              data: (data) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('الصلوات', '${data?.prayerCount ?? 0}/5', Icons.mosque, Colors.green, onTap: () => _updatePrayerCount(data)),
                  _buildStatItem('الأذكار', '${(data?.morningAzkar ?? false ? 1 : 0) + (data?.eveningAzkar ?? false ? 1 : 0)}/2',
                      Icons.favorite, Colors.red,
                      onTap: () => _toggleAzkar(data)),
                  _buildStatItem('الورد', 'جاري', Icons.menu_book, Colors.blue),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('خطأ: $err'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrayerLogDialog(DailyCommitmentData? data) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final prayers = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
          final jamaah = data?.jamaahPrayers?.split(',') ?? [];
          final sunnah = data?.sunnahPrayers?.split(',') ?? [];

          return AlertDialog(
            title: const Text('تفاصيل الصلوات اليومية'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(prayers.length, (index) {
                final p = prayers[index];
                return Row(
                  children: [
                    Expanded(child: Text(p)),
                    const Text('جماعة'),
                    Checkbox(
                      value: jamaah.contains(p),
                      onChanged: (val) => _updatePrayerLog(data, p, 'jamaah', val ?? false),
                    ),
                    const Text('سنن'),
                    Checkbox(
                      value: sunnah.contains(p),
                      onChanged: (val) => _updatePrayerLog(data, p, 'sunnah', val ?? false),
                    ),
                  ],
                );
              }),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
            ],
          );
        },
      ),
    ).then((_) => ref.invalidate(todayCommitmentProvider));
  }

  Future<void> _updatePrayerLog(DailyCommitmentData? data, String prayer, String type, bool value) async {
    final db = ref.read(databaseProvider);
    var jamaah = data?.jamaahPrayers?.split(',').where((e) => e.isNotEmpty).toList() ?? [];
    var sunnah = data?.sunnahPrayers?.split(',').where((e) => e.isNotEmpty).toList() ?? [];

    if (type == 'jamaah') {
      value ? jamaah.add(prayer) : jamaah.remove(prayer);
    } else {
      value ? sunnah.add(prayer) : sunnah.remove(prayer);
    }

    final newCount = jamaah.toSet().union(sunnah.toSet()).length; // Over-simplified count logic

    if (data == null) {
      await db.into(db.dailyCommitment).insert(DailyCommitmentCompanion.insert(
            date: DateTime.now(),
            prayerCount: drift.Value(newCount),
            jamaahPrayers: drift.Value(jamaah.join(',')),
            sunnahPrayers: drift.Value(sunnah.join(',')),
          ));
    } else {
      await (db.update(db.dailyCommitment)..where((t) => t.id.equals(data.id))).write(DailyCommitmentCompanion(
        prayerCount: drift.Value(newCount),
        jamaahPrayers: drift.Value(jamaah.join(',')),
        sunnahPrayers: drift.Value(sunnah.join(',')),
      ));
    }
  }

  Future<void> _updatePrayerCount(DailyCommitmentData? data) async {
    _showPrayerLogDialog(data);
  }

  Future<void> _toggleAzkar(DailyCommitmentData? data) async {
    final db = ref.read(databaseProvider);
    if (data == null) {
      await db.into(db.dailyCommitment).insert(DailyCommitmentCompanion.insert(
            date: DateTime.now(),
            morningAzkar: const drift.Value(true),
          ));
    } else {
      if (!data.morningAzkar) {
        await (db.update(db.dailyCommitment)..where((t) => t.id.equals(data.id))).write(const DailyCommitmentCompanion(morningAzkar: drift.Value(true)));
      } else if (!data.eveningAzkar) {
        await (db.update(db.dailyCommitment)..where((t) => t.id.equals(data.id))).write(const DailyCommitmentCompanion(eveningAzkar: drift.Value(true)));
      } else {
        await (db.update(db.dailyCommitment)..where((t) => t.id.equals(data.id)))
            .write(const DailyCommitmentCompanion(morningAzkar: drift.Value(false), eveningAzkar: drift.Value(false)));
      }
    }
    ref.invalidate(todayCommitmentProvider);
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCountdownCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black45,
      color: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [Color(0xFF263238), Color(0xFF455A64)]),
        ),
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('الوقت المتبقي لصلاة $_nextPrayerName', style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              _formatDuration(_timeLeft),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildDailyVerse(WidgetRef ref) {
    final verseAsync = ref.watch(dailyVerseProvider);
    return Card(
      elevation: 0,
      color: Colors.green.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.green)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.green),
                SizedBox(width: 10),
                Text('آية اليوم', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 10),
            verseAsync.when(
              data: (verse) => Column(
                children: [
                  Text(
                    verse?.verseText ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Amiri'),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'سورة ${verse?.surahNumber} - آية ${verse?.ayahNumber}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => const Text('الحمد لله رب العالمين'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiritualChecklist() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final today = DateTime.now().toIso8601String().split('T')[0];

    final items = [
      {'key': 'checklist_duha', 'label': 'صلاة الضحى'},
      {'key': 'checklist_witr', 'label': 'صلاة الوتر'},
      {'key': 'checklist_kahf', 'label': 'سورة الكهف (الجمعة)', 'only_friday': true},
      {'key': 'checklist_charity', 'label': 'صدقة اليوم'},
    ];

    final isFriday = DateTime.now().weekday == DateTime.friday;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('قائمة السنن والآداب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...items.where((i) => i['only_friday'] != true || isFriday).map((item) {
              final key = '${item['key']}_$today';
              final isDone = prefs.getBool(key) ?? false;
              return CheckboxListTile(
                title: Text(item['label'] as String),
                value: isDone,
                onChanged: (val) {
                  prefs.setBool(key, val ?? false);
                  setState(() {});
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiritualTip(WidgetRef ref) {
    final tip = ref.watch(spiritualTipProvider);
    return Card(
      elevation: 0,
      color: Colors.blue.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.blue)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.blue),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                tip,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaOfDay(WidgetRef ref) {
    final duaAsync = ref.watch(randomDuaProvider);
    return Card(
      elevation: 0,
      color: Colors.amber.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.amber)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.format_quote, color: Colors.amber),
                SizedBox(width: 10),
                Text('دعاء اليوم', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
              ],
            ),
            const SizedBox(height: 10),
            duaAsync.when(
              data: (dua) => Text(
                dua?.zikrText ?? 'اللهم اهدنا فيمن هديت',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => const Text('سبحان الله وبحمده'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastReadCard(BuildContext context, int number, String name) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: ListTile(
        title: const Text('واصل القراءة', style: TextStyle(color: Colors.white70)),
        subtitle: Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SurahDetailScreen(surahNumber: number, surahName: name),
          ));
        },
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, Color color, {Widget? destination}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          if (destination != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => destination));
          }
        },
      ),
    );
  }
}

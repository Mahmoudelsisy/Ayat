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

final readAyahsCountProvider = FutureProvider<int>((ref) async {
  final db = ref.read(databaseProvider);
  final countExp = db.userProgress.id.count();
  final query = db.selectOnly(db.userProgress)..addColumns([countExp]);
  final result = await query.getSingle();
  return result.read(countExp) as int? ?? 0;
});

final randomDuaProvider = FutureProvider<AzkarData?>((ref) async {
  final db = ref.read(databaseProvider);
  final query = db.select(db.azkar)..orderBy([(t) => drift.OrderingTerm.random()])..limit(1);
  return await query.getSingleOrNull();
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
      appBar: AppBar(title: const Text('آيات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_nextPrayerName.isNotEmpty) _buildCountdownCard(),
          const SizedBox(height: 20),
          if (lastSurahNum != null) ...[
            _buildLastReadCard(context, lastSurahNum, lastSurahName!),
            const SizedBox(height: 20),
          ],
          _buildDuaOfDay(ref),
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
          _buildQuickAction(context, 'الإحصائيات والتقدم', Icons.bar_chart, Colors.blue, destination: const StatsScreen()),
          _buildQuickAction(context, 'وضع السفر (قصر الصلاة)', Icons.flight_takeoff, Colors.blueAccent, destination: const TravelModeScreen()),
          _buildQuickAction(context, 'التقويم الهجري والمناسبات', Icons.calendar_today, Colors.teal, destination: const CalendarScreen()),
          _buildQuickAction(context, 'مقارنة القراء', Icons.compare, Colors.brown, destination: const AudioComparisonScreen()),
          _buildQuickAction(context, 'أسماء الله الحسنى', Icons.auto_awesome, Colors.amber, destination: const AllahNamesScreen()),
          _buildQuickAction(context, 'مخطط الختمة', Icons.edit_calendar, Colors.deepOrange, destination: const KhatmaPlannerScreen()),
          _buildQuickAction(context, 'المرجعيات', Icons.bookmark, Colors.red, destination: const BookmarksScreen()),
          _buildQuickAction(context, 'الأوضاع الخاصة (قيام، خلوة)', Icons.brightness_4, Colors.purple, destination: const ModesScreen()),
          _buildQuickAction(context, 'أذكار الصباح', Icons.wb_sunny, Colors.orange),
          _buildQuickAction(context, 'أذكار المساء', Icons.nightlight_round, Colors.indigo),
          _buildQuickAction(context, 'سورة الكهف', Icons.menu_book, Colors.green),
        ],
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
    return Card(
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('مؤشرات الالتزام اليومي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('الصلوات', '5/5', Icons.mosque, Colors.green),
                _buildStatItem('الأذكار', '2/2', Icons.favorite, Colors.red),
                _buildStatItem('الورد', '10ص', Icons.menu_book, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCountdownCard() {
    return Card(
      color: Colors.blueGrey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('الوقت المتبقي لصلاة $_nextPrayerName', style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              _formatDuration(_timeLeft),
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2),
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

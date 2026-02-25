import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../prayer_times/providers/prayer_times_provider.dart';
import '../views/itikaf_screen.dart';
import '../../home/views/khatma_planner_screen.dart';
import '../../azkar/views/ruqyah_screen.dart';

class RamadanView extends ConsumerStatefulWidget {
  const RamadanView({super.key});

  @override
  ConsumerState<RamadanView> createState() => _RamadanViewState();
}

class _RamadanViewState extends ConsumerState<RamadanView> {
  Timer? _timer;
  Duration _toIftar = Duration.zero;
  Duration _toSuhoor = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateCountdowns();
    });
  }

  void _calculateCountdowns() {
    final prayerTimesAsync = ref.read(prayerTimesProvider);
    prayerTimesAsync.whenData((times) {
      final now = DateTime.now();

      final maghrib = times.maghrib;
      final fajr = times.fajr;
      final nextFajr = times.fajr.add(const Duration(days: 1));

      setState(() {
        if (now.isBefore(maghrib)) {
          _toIftar = maghrib.difference(now);
        } else {
          _toIftar = Duration.zero;
        }

        if (now.isBefore(fajr)) {
          _toSuhoor = fajr.difference(now);
        } else if (now.isAfter(maghrib)) {
          _toSuhoor = nextFajr.difference(now);
        } else {
          _toSuhoor = Duration.zero; // Between Fajr and Maghrib
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('وضع رمضان')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade900, Colors.black],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCountdownCard('الوقت المتبقي للإفطار', _toIftar, Icons.wb_twilight, Colors.orange),
            const SizedBox(height: 16),
            _buildCountdownCard('الوقت المتبقي للإمساك (السحور)', _toSuhoor, Icons.nights_stay, Colors.blue),
            const SizedBox(height: 24),
            _buildActionCard(
              context,
              'مخطط الختمة الرمضانية',
              'نظم قراءتك لتختم القرآن في رمضان',
              Icons.menu_book,
              Colors.green,
              const KhatmaPlannerScreen(),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              'أذكار الصائم والرقية',
              'أدعية مأثورة ورقيه شرعية',
              Icons.favorite,
              Colors.redAccent,
              RuqyahScreen(),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              'وضع الاعتكاف',
              'خلوة مع النفس والذكر',
              Icons.self_improvement,
              Colors.teal,
              const ItikafScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownCard(String title, Duration duration, IconData icon, Color color) {
    return Card(
      color: Colors.white.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              _formatDuration(duration),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String sub, IconData icon, Color color, Widget destination) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
      ),
    );
  }
}

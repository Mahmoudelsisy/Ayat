import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../core/services/notification_service.dart';
import 'itikaf_screen.dart';

class ModesScreen extends ConsumerStatefulWidget {
  const ModesScreen({super.key});

  @override
  ConsumerState<ModesScreen> createState() => _ModesScreenState();
}

class _ModesScreenState extends ConsumerState<ModesScreen> {
  bool _isQiyamMode = false;
  Timer? _qiyamTimer;
  int _secondsElapsed = 0;


  void _toggleQiyam() {
    setState(() {
      _isQiyamMode = !_isQiyamMode;
      if (_isQiyamMode) {
        _secondsElapsed = 0;
        _qiyamTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() => _secondsElapsed++);
        });
        _scheduleQiyamReminder();
      } else {
        _qiyamTimer?.cancel();
      }
    });
  }

  void _scheduleQiyamReminder() {
    NotificationService().scheduleDailyNotification(
      200,
      'موعد قيام الليل',
      'تذكير بصلاة قيام الليل، شرف المؤمن قيامه بالليل',
      2, // 2 AM
      0,
    );
  }

  void _toggleKhalwa() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ItikafScreen()));
  }

  String _formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أوضاع خاصة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildModeCard(
            title: 'وضع قيام الليل',
            description: 'تتبع وقت صلاتك وقيامك',
            icon: Icons.nightlight_round,
            color: Colors.indigo,
            isActive: _isQiyamMode,
            onToggle: _toggleQiyam,
            extra: _isQiyamMode ? Text('الوقت المنقضي: ${_formatTime(_secondsElapsed)}', style: const TextStyle(fontSize: 18)) : null,
          ),
          const SizedBox(height: 20),
          _buildModeCard(
            title: 'وضع الاعتكاف / الخلوة',
            description: 'تركيز كامل مع ذكر متكرر ومنع الإزعاج',
            icon: Icons.self_improvement,
            color: Colors.teal,
            isActive: false,
            onToggle: _toggleKhalwa,
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isActive,
    required VoidCallback onToggle,
    Widget? extra,
  }) {
    return Card(
      elevation: isActive ? 8 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, size: 40, color: color),
              title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text(description),
              trailing: Switch(value: isActive, onChanged: (_) => onToggle()),
            ),
            if (extra != null) ...[
              const Divider(),
              extra,
            ],
          ],
        ),
      ),
    );
  }
}

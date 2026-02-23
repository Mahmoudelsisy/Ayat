import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class ModesScreen extends ConsumerStatefulWidget {
  const ModesScreen({super.key});

  @override
  ConsumerState<ModesScreen> createState() => _ModesScreenState();
}

class _ModesScreenState extends ConsumerState<ModesScreen> {
  bool _isQiyamMode = false;
  Timer? _qiyamTimer;
  int _secondsElapsed = 0;

  bool _isKhalwaMode = false;

  void _toggleQiyam() {
    setState(() {
      _isQiyamMode = !_isQiyamMode;
      if (_isQiyamMode) {
        _secondsElapsed = 0;
        _qiyamTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() => _secondsElapsed++);
        });
      } else {
        _qiyamTimer?.cancel();
      }
    });
  }

  void _toggleKhalwa() {
    setState(() {
      _isKhalwaMode = !_isKhalwaMode;
      // In a real app, this would use a platform channel to enable DND
    });
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
            title: 'وضع الخلوة',
            description: 'تركيز كامل مع ذكر متكرر ومنع الإزعاج',
            icon: Icons.self_improvement,
            color: Colors.teal,
            isActive: _isKhalwaMode,
            onToggle: _toggleKhalwa,
            extra: _isKhalwaMode ? const Text('وضع الخلوة نشط... ذكر متكرر يعمل في الخلفية', style: TextStyle(fontStyle: FontStyle.italic)) : null,
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

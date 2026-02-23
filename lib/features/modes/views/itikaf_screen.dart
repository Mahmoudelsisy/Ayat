import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class ItikafScreen extends ConsumerStatefulWidget {
  const ItikafScreen({super.key});

  @override
  ConsumerState<ItikafScreen> createState() => _ItikafScreenState();
}

class _ItikafScreenState extends ConsumerState<ItikafScreen> {
  final List<String> _zikrs = [
    'سبحان الله وبحمده، سبحان الله العظيم',
    'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير',
    'أستغفر الله وأتوب إليه',
    'اللهم صل وسلم على نبينا محمد',
    'لا حول ولا قوة إلا بالله العلي العظيم',
    'سبحان الله، والحمد لله، ولا إله إلا الله، والله أكبر',
  ];
  int _currentIndex = 0;
  Timer? _timer;
  Timer? _sessionTimer;
  int _seconds = 0;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 12), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _zikrs.length;
        });
      }
    });
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _seconds++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.self_improvement, size: 80, color: Colors.teal),
                const SizedBox(height: 20),
                Text(
                  _formatDuration(_seconds),
                  style: const TextStyle(color: Colors.teal, fontSize: 24, letterSpacing: 2, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 2),
                    child: Text(
                      _zikrs[_currentIndex],
                      key: ValueKey(_currentIndex),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                        shadows: [Shadow(color: Colors.teal, blurRadius: 20)],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white54),
                      onPressed: () => setState(() => _isMuted = !_isMuted),
                    ),
                    const SizedBox(width: 40),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = (_currentIndex + 1) % _zikrs.length;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.withValues(alpha: 0.2),
                        foregroundColor: Colors.teal,
                        side: const BorderSide(color: Colors.teal),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text('الذكر التالي'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: _finishSession,
                  child: const Text('إنهاء الجلسة', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Text(
              'في خلوة مع الله...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white24, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _finishSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انتهت الخلوة'),
        content: Text('بارك الله فيك. قضيت في ذكر الله: ${_formatDuration(_seconds)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit Itikaf
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}

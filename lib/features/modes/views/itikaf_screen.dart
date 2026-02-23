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

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _zikrs.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.self_improvement, size: 80, color: Colors.teal),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: Text(
                  _zikrs[_currentIndex],
                  key: ValueKey(_currentIndex),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, color: Colors.white, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentIndex = (_currentIndex + 1) % _zikrs.length;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('الذكر التالي'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إنهاء وضع الاعتكاف', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}

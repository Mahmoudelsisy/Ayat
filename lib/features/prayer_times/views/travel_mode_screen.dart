import 'package:flutter/material.dart';
import 'dart:async';

class TravelModeScreen extends StatefulWidget {
  const TravelModeScreen({super.key});

  @override
  State<TravelModeScreen> createState() => _TravelModeScreenState();
}

class _TravelModeScreenState extends State<TravelModeScreen> {
  bool _isTravelModeActive = false;
  Timer? _timer;
  int _secondsRemaining = 0;

  void _startTravelTimer(int minutes) {
    setState(() {
      _isTravelModeActive = true;
      _secondsRemaining = minutes * 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        setState(() => _isTravelModeActive = false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
      appBar: AppBar(title: const Text('وضع السفر')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.blueAccent,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.flight_takeoff, size: 50, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'رخصة السفر (قصر الصلاة)',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'يجوز للمسافر قصر الصلاة الرباعية إلى ركعتين، وجمع الظهر مع العصر، والمغرب مع العشاء.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (_isTravelModeActive)
              Column(
                children: [
                  const Text('مؤقت الصلاة القادمة (قصر)', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text(
                    _formatTime(_secondsRemaining),
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _isTravelModeActive = false;
                      _timer?.cancel();
                    }),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: const Text('إلغاء المؤقت'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Text('اختر مدة التنبيه للصلاة القادمة', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTimerOption(30, '30 دقيقة'),
                      _buildTimerOption(60, 'ساعة'),
                      _buildTimerOption(120, 'ساعتان'),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerOption(int mins, String label) {
    return ElevatedButton(
      onPressed: () => _startTravelTimer(mins),
      child: Text(label),
    );
  }
}

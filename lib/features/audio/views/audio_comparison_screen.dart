import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../audio/providers/audio_provider.dart';

class AudioComparisonScreen extends ConsumerStatefulWidget {
  const AudioComparisonScreen({super.key});

  @override
  ConsumerState<AudioComparisonScreen> createState() => _AudioComparisonScreenState();
}

class _AudioComparisonScreenState extends ConsumerState<AudioComparisonScreen> {
  Reciter? _reciter1;
  Reciter? _reciter2;
  int _selectedSurah = 1;
  int _selectedAyah = 1;
  late AudioPlayer _player1;
  late AudioPlayer _player2;
  bool _isPlaying1 = false;
  bool _isPlaying2 = false;

  @override
  void initState() {
    super.initState();
    _player1 = AudioPlayer();
    _player2 = AudioPlayer();
    _reciter1 = reciters[0];
    _reciter2 = reciters[1];
  }

  @override
  void dispose() {
    _player1.dispose();
    _player2.dispose();
    super.dispose();
  }

  int _getAbsoluteAyahNumber(int surah, int ayah) {
    return _surahStartAyahs[surah - 1] + ayah;
  }

  static const _surahStartAyahs = [
    0, 7, 293, 493, 669, 789, 954, 1160, 1235, 1364, 1473, 1596, 1707, 1750, 1802, 1901, 2029, 2140, 2250, 2348, 2483, 2595, 2673, 2791, 2855, 2932, 3159, 3252, 3340, 3409, 3469, 3503, 3533, 3606, 3660, 3705, 3788, 3970, 4058, 4133, 4218, 4272, 4325, 4414, 4473, 4510, 4545, 4583, 4601, 4619, 4664, 4724, 4776, 4789, 4826, 4904, 5000, 5052, 5064, 5088, 5101, 5115, 5123, 5134, 5152, 5164, 5176, 5206, 5258, 5286, 5314, 5342, 5370, 5398, 5426, 5454, 5485, 5522, 5552, 5580, 5622, 5650, 5658, 5694, 5719, 5747, 5762, 5781, 5803, 5833, 5853, 5864, 5875, 5880, 5885, 5893, 5898, 5901, 5909, 5912, 5923, 5934, 5942, 5945, 5952, 5957, 5962, 5969, 5972, 5978, 5981, 5984, 5988, 5993, 5998
  ];

  Future<void> _play(int playerNum) async {
    final player = playerNum == 1 ? _player1 : _player2;
    final reciter = playerNum == 1 ? _reciter1 : _reciter2;
    if (reciter == null) return;

    final absoluteAyah = _getAbsoluteAyahNumber(_selectedSurah, _selectedAyah);
    final url = 'https://cdn.islamic.network/quran/audio/128/${reciter.ayahServerId}/$absoluteAyah.mp3';

    try {
      await player.setUrl(url);
      player.play();
      if (mounted) {
        setState(() {
          if (playerNum == 1) {
            _isPlaying1 = true;
          } else {
            _isPlaying2 = true;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مقارنة القراء')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('قارن بين أداء القراء لنفس الآية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildReciterSelector(1),
            const SizedBox(height: 10),
            _buildReciterSelector(2),
            const SizedBox(height: 30),
            _buildAyahSelector(),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlayerControl(1),
                _buildPlayerControl(2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReciterSelector(int num) {
    return DropdownButtonFormField<Reciter>(
      initialValue: num == 1 ? _reciter1 : _reciter2,
      decoration: InputDecoration(labelText: 'القارئ $num'),
      items: reciters.map((r) => DropdownMenuItem(value: r, child: Text(r.name))).toList(),
      onChanged: (val) => setState(() {
        if (num == 1) {
          _reciter1 = val;
        } else {
          _reciter2 = val;
        }
      }),
    );
  }

  Widget _buildAyahSelector() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: _selectedSurah.toString(),
            decoration: const InputDecoration(labelText: 'رقم السورة'),
            keyboardType: TextInputType.number,
            onChanged: (val) => _selectedSurah = int.tryParse(val) ?? 1,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            initialValue: _selectedAyah.toString(),
            decoration: const InputDecoration(labelText: 'رقم الآية'),
            keyboardType: TextInputType.number,
            onChanged: (val) => _selectedAyah = int.tryParse(val) ?? 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerControl(int num) {
    final isPlaying = num == 1 ? _isPlaying1 : _isPlaying2;
    final reciter = num == 1 ? _reciter1 : _reciter2;

    return Column(
      children: [
        Text(reciter?.name ?? 'اختر قارئ', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        IconButton.filled(
          iconSize: 40,
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () => _play(num),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TasbeehView extends StatefulWidget {
  const TasbeehView({super.key});

  @override
  State<TasbeehView> createState() => _TasbeehViewState();
}

class _TasbeehViewState extends State<TasbeehView> {
  int _counter = 0;
  String _selectedZikr = 'سبحان الله وبحمده';
  int _target = 33;
  double _scale = 1.0;

  final List<Map<String, dynamic>> _zikrPresets = [
    {'text': 'سبحان الله وبحمده', 'target': 33},
    {'text': 'سبحان الله العظيم', 'target': 33},
    {'text': 'الحمد لله', 'target': 33},
    {'text': 'الله أكبر', 'target': 33},
    {'text': 'لا إله إلا الله', 'target': 100},
    {'text': 'أستغفر الله', 'target': 100},
    {'text': 'اللهم صل وسلم على نبينا محمد', 'target': 100},
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomPresets();
  }

  Future<void> _loadCustomPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final customData = prefs.getString('custom_zikrs');
    if (customData != null) {
      final List<dynamic> decoded = jsonDecode(customData);
      setState(() {
        _zikrPresets.addAll(decoded.cast<Map<String, dynamic>>());
      });
    }
  }

  Future<void> _saveCustomPresets() async {
    final prefs = await SharedPreferences.getInstance();
    const defaultCount = 7;
    if (_zikrPresets.length > defaultCount) {
      final customOnly = _zikrPresets.sublist(defaultCount);
      await prefs.setString('custom_zikrs', jsonEncode(customOnly));
    }
  }

  void _increment() {
    HapticFeedback.vibrate();
    setState(() {
      _counter++;
      _scale = 0.95;
      if (_counter == _target) {
        HapticFeedback.heavyImpact();
        _showCompletionDialog();
      }
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _scale = 1.0);
    });
  }

  void _showAddCustomZikr() {
    final textController = TextEditingController();
    final targetController = TextEditingController(text: '33');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة ذكر مخصص'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'نص الذكر'),
            ),
            TextField(
              controller: targetController,
              decoration: const InputDecoration(labelText: 'العدد المستهدف'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                setState(() {
                  _zikrPresets.add({
                    'text': textController.text,
                    'target': int.tryParse(targetController.text) ?? 33,
                  });
                  _selectedZikr = textController.text;
                  _target = int.tryParse(targetController.text) ?? 33;
                  _counter = 0;
                });
                await _saveCustomPresets();
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم بنجاح'),
        content: Text('لقد أتممت $_target من ذِكر: $_selectedZikr'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('السبحة الإلكترونية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCustomZikr,
            tooltip: 'إضافة ذكر مخصص',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _counter = 0),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _zikrPresets.length,
              itemBuilder: (context, index) {
                final preset = _zikrPresets[index];
                final isSelected = _selectedZikr == preset['text'];
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ChoiceChip(
                    label: Text(preset['text']),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedZikr = preset['text'];
                          _target = preset['target'];
                          _counter = 0;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _selectedZikr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('الهدف: $_target', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _increment,
                    child: AnimatedScale(
                      scale: _scale,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 10,
                            ),
                          ],
                          gradient: RadialGradient(
                            colors: [
                              Theme.of(context).primaryColor.withValues(alpha: 0.8),
                              Theme.of(context).primaryColor,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$_counter',
                            style: const TextStyle(fontSize: 64, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'اضغط على الدائرة للتسبيح',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

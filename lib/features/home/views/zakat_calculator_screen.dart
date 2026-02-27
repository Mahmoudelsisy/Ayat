import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/digits_provider.dart';

class ZakatCalculatorScreen extends ConsumerStatefulWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  ConsumerState<ZakatCalculatorScreen> createState() => _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends ConsumerState<ZakatCalculatorScreen> {
  final _amountController = TextEditingController();
  double _zakatAmount = 0;
  bool _isEligible = false;

  // Example Nisab (Should ideally be fetched from an API)
  static const double _nisabGold = 85.0; // grams
  static const double _goldPricePerGram = 70.0; // USD/Any Currency

  void _calculate() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final nisab = _nisabGold * _goldPricePerGram;

    setState(() {
      if (amount >= nisab) {
        _isEligible = true;
        _zakatAmount = amount * 0.025;
      } else {
        _isEligible = false;
        _zakatAmount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final arabicDigits = ref.watch(arabicDigitsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('حاسبة الزكاة')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.amber,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.calculate, size: 40, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'الزكاة ركن من أركان الإسلام، تُحسب بنسبة 2.5% من المال الذي حال عليه الحول وبلغ النصاب.',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'إجمالي المبلغ المالي',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 30),
            if (_isEligible)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  children: [
                    const Text('مقدار الزكاة الواجبة:', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                      _zakatAmount.toStringAsFixed(2).toArabicDigits(arabicDigits),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              )
            else if (_amountController.text.isNotEmpty)
              const Center(
                child: Text(
                  'المبلغ لم يبلغ النصاب بعد.',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

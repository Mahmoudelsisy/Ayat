import 'package:flutter/material.dart';

class RuqyahScreen extends StatelessWidget {
  const RuqyahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ruqyahItems = [
      {
        'title': 'سورة الفاتحة',
        'content': 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ (1) الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ (2) الرَّحْمَنِ الرَّحِيمِ (3) مَالِكِ يَوْمِ الدِّينِ (4) إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ (5) اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ (6) صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ (7)',
      },
      {
        'title': 'آية الكرسي',
        'content': 'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
      },
      {
        'title': 'المعوذات',
        'content': 'سورة الإخلاص، الفلق، والناس (ثلاث مرات)',
      },
      {
        'title': 'دعاء النبوي',
        'content': 'أعوذ بكلمات الله التامات من شر ما خلق',
      },
      {
        'title': 'دعاء النبوي',
        'content': 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('الرقية الشرعية')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ruqyahItems.length,
        itemBuilder: (context, index) {
          final item = ruqyahItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item['title']!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    textAlign: TextAlign.right,
                  ),
                  const Divider(),
                  Text(
                    item['content']!,
                    style: const TextStyle(fontSize: 20, height: 1.6, fontFamily: 'Amiri'),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

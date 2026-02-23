import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../quran/views/surah_list_screen.dart';
import '../../prayer_times/views/prayer_times_view.dart';
import '../../azkar/views/azkar_categories_screen.dart';
import '../../qibla/views/qibla_view.dart';
import '../../settings/views/settings_view.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);

    final screens = [
      const PrayerTimesView(),
      const SurahListScreen(),
      const AzkarCategoriesScreen(),
      const QiblaView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => ref.read(bottomNavIndexProvider.notifier).state = i,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'مواقيت الصلاة'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'القرآن'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'الأذكار'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'القبلة'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}

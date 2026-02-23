import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../prayer_times/providers/prayer_settings_provider.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  void _showCalculationMethodDialog(BuildContext context, WidgetRef ref) {
    final methods = {
      'umm_al_qura': 'أم القرى',
      'muslim_world_league': 'رابطة العالم الإسلامي',
      'egyptian': 'الهيئة المصرية العامة للمساحة',
      'karachi': 'جامعة العلوم الإسلامية بكراتشي',
      'dubai': 'دبي',
      'kuwait': 'الكويت',
      'qatar': 'قطر',
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('طريقة الحساب'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: methods.entries.map((e) => ListTile(
              title: Text(e.value),
              onTap: () {
                final prefs = ref.read(sharedPreferencesProvider);
                prefs.setString('prayer_method', e.key);
                ref.invalidate(prayerSettingsProvider);
                Navigator.pop(context);
              },
            )).toList(),
          ),
        ),
      ),
    );
  }

  void _showMadhabDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('المذهب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('شافعي، مالكي، حنبلي'),
              onTap: () {
                final prefs = ref.read(sharedPreferencesProvider);
                prefs.setString('prayer_madhab', 'shafi');
                ref.invalidate(prayerSettingsProvider);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('حنفي'),
              onTap: () {
                final prefs = ref.read(sharedPreferencesProvider);
                prefs.setString('prayer_madhab', 'hanafi');
                ref.invalidate(prayerSettingsProvider);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('طريقة حساب الصلاة'),
            subtitle: const Text('اضغط للتغيير'),
            onTap: () => _showCalculationMethodDialog(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.rule),
            title: const Text('المذهب (العصر)'),
            subtitle: const Text('اضغط للتغيير'),
            onTap: () => _showMadhabDialog(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'),
            onTap: () {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('تنبيهات الأذان'),
            value: true,
            onChanged: (val) {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('الوضع الليلي'),
            value: themeMode == ThemeMode.dark,
            onChanged: (val) {
              final prefs = ref.read(sharedPreferencesProvider);
              prefs.setBool('is_dark', val);
              ref.read(themeModeProvider.notifier).state = val ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('رواية القراءة'),
            subtitle: const Text('حفص عن عاصم'),
            onTap: () {
              // Show dialog to select reading
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('اختر الرواية'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(title: Text('حفص عن عاصم'), trailing: Icon(Icons.check, color: Colors.green)),
                      ListTile(title: Text('ورش عن نافع (قريباً)')),
                      ListTile(title: Text('قالون عن نافع (قريباً)')),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('اللغة'),
            subtitle: const Text('العربية'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('عن التطبيق'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Ayat | آيات',
                applicationVersion: '1.0.0',
                applicationIcon: Image.asset('assets/images/Logo.png', width: 50),
              );
            },
          ),
        ],
      ),
    );
  }
}

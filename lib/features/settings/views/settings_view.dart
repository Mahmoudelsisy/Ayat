import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../prayer_times/providers/prayer_settings_provider.dart';
import '../../../shared/providers/reading_provider.dart';
import '../../../core/services/data_download_service.dart';

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

  void _showColorPickerDialog(BuildContext context, WidgetRef ref) {
    final colors = {
      'الأخضر': const Color(0xFF1B5E20),
      'الأزرق': const Color(0xFF0D47A1),
      'البني': const Color(0xFF4E342E),
      'الأرجواني': const Color(0xFF4A148C),
      'الذهبي': const Color(0xFFBF9B30),
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر لون التطبيق'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: colors.entries.map((e) => ListTile(
            leading: CircleAvatar(backgroundColor: e.value),
            title: Text(e.key),
            onTap: () {
              final prefs = ref.read(sharedPreferencesProvider);
              // ignore: deprecated_member_use
              prefs.setInt('theme_color', e.value.value);
              ref.read(themeColorProvider.notifier).state = e.value;
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showReadingSelection(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final selected = ref.watch(selectedReadingProvider);
          return AlertDialog(
            title: const Text('اختر الرواية'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: availableReadings.entries.map((e) {
                return ListTile(
                  title: Text(e.value),
                  trailing: selected == e.key ? const Icon(Icons.check, color: Colors.green) : null,
                  onTap: () async {
                    final db = ref.read(databaseProvider);
                    final service = DataDownloadService(db);

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري التأكد من توفر البيانات...')));

                    await service.downloadQuran(edition: e.key);

                    final prefs = ref.read(sharedPreferencesProvider);
                    prefs.setString('quran_reading', e.key);
                    ref.read(selectedReadingProvider.notifier).state = e.key;

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تغيير الرواية بنجاح')));
                    }
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showMuadhinSelection(BuildContext context, WidgetRef ref) {
    final muadhins = {
      'default': 'الافتراضي',
      'mecca': 'مكة المكرمة',
      'medina': 'المدينة المنورة',
      'al_aqsa': 'المسجد الأقصى',
      'mishary': 'مشاري العفاسي',
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر صوت الأذان'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: muadhins.entries
              .map((e) => ListTile(
                    title: Text(e.value),
                    onTap: () {
                      final prefs = ref.read(sharedPreferencesProvider);
                      prefs.setString('muadhin', e.value);
                      // In a real app, ref.invalidate or similar would trigger UI update
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
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
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('صوت الأذان'),
            subtitle: Text(ref.watch(sharedPreferencesProvider).getString('muadhin') ?? 'الافتراضي'),
            onTap: () => _showMuadhinSelection(context, ref),
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
          SwitchListTile(
            secondary: const Icon(Icons.lock),
            title: const Text('قفل التطبيق'),
            subtitle: const Text('استخدم بصمة الإصبع أو رمز الجهاز'),
            value: ref.watch(isAppLockedProvider),
            onChanged: (val) {
              final prefs = ref.read(sharedPreferencesProvider);
              prefs.setBool('is_locked', val);
              ref.read(isAppLockedProvider.notifier).state = val;
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('لون التطبيق'),
            subtitle: const Text('اختر لونك المفضل'),
            onTap: () => _showColorPickerDialog(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('رواية القراءة'),
            subtitle: const Text('حفص عن عاصم'),
            onTap: () => _showReadingSelection(context, ref),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
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

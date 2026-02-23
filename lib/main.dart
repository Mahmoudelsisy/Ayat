import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared/themes/app_theme.dart';
import 'core/database/database.dart';
import 'core/services/data_download_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/auth_service.dart';
import 'features/home/views/main_screen.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  final sharedPrefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const AyatApp(),
    ),
  );
}

class AyatApp extends ConsumerWidget {
  const AyatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Ayat | آيات',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}

final downloadProgressProvider = StateProvider<double>((ref) => 0.0);
final isDownloadingProvider = StateProvider<bool>((ref) => false);
final isAppLockedProvider = StateProvider<bool>((ref) => false);
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final isDark = prefs.getBool('is_dark') ?? false;
  return isDark ? ThemeMode.dark : ThemeMode.light;
});

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkData();
  }

  Future<void> _checkData() async {
    // Auth Check
    final isLocked = ref.read(isAppLockedProvider);
    if (isLocked) {
      final authService = ref.read(authServiceProvider);
      final authenticated = await authService.authenticate();
      if (!authenticated) {
        // App remains locked or exits
        return;
      }
    }

    final db = ref.read(databaseProvider);
    final quranCount = await (db.select(db.quran)..limit(1)).get();

    if (quranCount.isEmpty) {
      if (mounted) {
        ref.read(isDownloadingProvider.notifier).state = true;
        final service = DataDownloadService(db);
        await service.downloadAllData((progress) {
          if (mounted) {
            ref.read(downloadProgressProvider.notifier).state = progress;
          }
        });
        if (mounted) {
          ref.read(isDownloadingProvider.notifier).state = false;
        }
      }
    }

    if (mounted) {
      // Navigate to Home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(downloadProgressProvider);
    final isDownloading = ref.watch(isDownloadingProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Logo.png', width: 150),
            const SizedBox(height: 20),
            const Text(
              'آيات',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.islamicGreen,
              ),
            ),
            const SizedBox(height: 20),
            if (isDownloading) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LinearProgressIndicator(value: progress),
              ),
              const SizedBox(height: 10),
              Text(
                'جاري تحميل البيانات... ${(progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 16),
              ),
            ] else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/services/mushaf_download_service.dart';
import '../../../shared/providers/digits_provider.dart';

final mushafPagesProvider = FutureProvider.family<List<int>, int>((ref, surahNumber) async {
  final db = ref.read(databaseProvider);
  final query = db.selectOnly(db.quran, distinct: true)
    ..addColumns([db.quran.pageNumber])
    ..where(db.quran.surahNumber.equals(surahNumber));
  final result = await query.get();
  return result.map((row) => row.read(db.quran.pageNumber)!).toList();
});

class MushafView extends ConsumerStatefulWidget {
  final int surahNumber;
  const MushafView({super.key, required this.surahNumber});

  @override
  ConsumerState<MushafView> createState() => _MushafViewState();
}

class _MushafViewState extends ConsumerState<MushafView> {
  int _currentPageIndex = 0;
  late PageController _pageController;
  final _downloadService = MushafDownloadService();
  bool _isDownloaded = false;
  bool _isDownloading = false;
  double _downloadProgress = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkDownloadStatus();
  }

  Future<void> _checkDownloadStatus() async {
    final status = await _downloadService.isMushafDownloaded();
    if (mounted) setState(() => _isDownloaded = status);
  }

  Future<void> _downloadMushaf() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    await _downloadService.downloadAllPages((progress) {
      if (mounted) setState(() => _downloadProgress = progress);
    });

    if (mounted) {
      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحميل المصحف بنجاح')));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagesAsync = ref.watch(mushafPagesProvider(widget.surahNumber));

    return pagesAsync.when(
      data: (pages) => Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            reverse: true, // Mushaf is right to left
            itemCount: pages.length,
            onPageChanged: (index) => setState(() => _currentPageIndex = index),
            itemBuilder: (context, index) {
              final pageNum = pages[index];
              return Center(
                child: InteractiveViewer(
                  child: FutureBuilder<String>(
                    future: _downloadService.getImagePath(pageNum),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && File(snapshot.data!).existsSync()) {
                        return Image.file(File(snapshot.data!));
                      }
                      final url = 'https://raw.githubusercontent.com/m4hmoud-atef/Islamic-and-quran-data/main/quran_images/quran_images_1/$pageNum.png';
                      return Image.network(
                        url,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (pages.length > 1)
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Slider(
                      value: _currentPageIndex.toDouble(),
                      min: 0,
                      max: (pages.length - 1).toDouble(),
                      onChanged: (val) {
                        _pageController.jumpToPage(val.toInt());
                      },
                      activeColor: Colors.green,
                      inactiveColor: Colors.white24,
                    ),
                  ),
                if (!_isDownloaded)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _isDownloading
                        ? SizedBox(
                            width: 200,
                            child: LinearProgressIndicator(value: _downloadProgress),
                          )
                        : ElevatedButton.icon(
                            onPressed: _downloadMushaf,
                            icon: const Icon(Icons.download),
                            label: const Text('تحميل المصحف للقراءة بدون إنترنت'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'صفحة ${pages[_currentPageIndex]}'.toArabicDigits(ref.watch(arabicDigitsProvider)),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }
}

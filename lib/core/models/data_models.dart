class QuranModel {
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final String? translation;

  QuranModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    this.translation,
  });
}

class AzkarModel {
  final String category;
  final String text;
  final String? reference;
  final int count;

  AzkarModel({
    required this.category,
    required this.text,
    this.reference,
    this.count = 1,
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Reciter {
  final String id;
  final String name;
  final String surahServer;
  final String ayahServerId;

  Reciter({
    required this.id,
    required this.name,
    required this.surahServer,
    required this.ayahServerId,
  });
}

final reciters = [
  Reciter(
    id: 'mishari_rashid_al-afasy',
    name: 'مشاري راشد العفاسي',
    surahServer: 'https://download.quranicaudio.com/quran/mishari_rashid_al-afasy/',
    ayahServerId: 'ar.alafasy',
  ),
  Reciter(
    id: 'abdul_basit_murattal',
    name: 'عبد الباسط عبد الصمد',
    surahServer: 'https://download.quranicaudio.com/quran/abdul_basit_murattal/',
    ayahServerId: 'ar.abdulbasitmurattal',
  ),
  Reciter(
    id: 'maher_almuaiqly',
    name: 'ماهر المعيقلي',
    surahServer: 'https://download.quranicaudio.com/quran/maher_almuaiqly/',
    ayahServerId: 'ar.maheralmuaiqly',
  ),
];

final selectedReciterProvider = StateProvider<Reciter>((ref) => reciters[0]);

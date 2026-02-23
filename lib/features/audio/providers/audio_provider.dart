import 'package:flutter_riverpod/flutter_riverpod.dart';

class Reciter {
  final String id;
  final String name;
  final String server;

  Reciter({required this.id, required this.name, required this.server});
}

final reciters = [
  Reciter(id: 'mishari_rashid_al-afasy', name: 'مشاري راشد العفاسي', server: 'https://download.quranicaudio.com/quran/mishari_rashid_al-afasy/'),
  Reciter(id: 'abdul_basit_murattal', name: 'عبد الباسط عبد الصمد', server: 'https://download.quranicaudio.com/quran/abdul_basit_murattal/'),
  Reciter(id: 'maher_almuaiqly', name: 'ماهر المعيقلي', server: 'https://download.quranicaudio.com/quran/maher_almuaiqly/'),
  Reciter(id: 'sa3d_al_ghamidi/murattal', name: 'سعد الغامدي', server: 'https://download.quranicaudio.com/quran/sa3d_al_ghamidi/murattal/'),
];

final selectedReciterProvider = StateProvider<Reciter>((ref) => reciters[0]);

import 'package:flutter/foundation.dart';

/// `destekOlAcilisRevizyonu`, ana kabuktan gelen "Destek Ol bolumunu ac"
/// isteklerini Ayarlar ekranina tasir.
final ValueNotifier<int> destekOlAcilisRevizyonu = ValueNotifier<int>(0);

void destekOlBolumunuAc() {
  destekOlAcilisRevizyonu.value += 1;
}

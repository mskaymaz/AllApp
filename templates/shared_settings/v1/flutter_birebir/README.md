# Flutter Birebir Sablon (v1)

Bu klasor, Rekat Sayar'daki asagidaki 5 Ayarlar yapisini birebir kod ve davranisla tasir:
- Bize Ulasin
- Uygulama Bilgileri ve Guncelleme
- Diger Uygulamalarimiz
- Destek Olabilirsiniz
- Biz Kimiz

## Icerik
- `lib/ozellikler/ayarlar/gorunum/ayarlar_bilesenleri.dart` (renk/karakter)
- `lib/ozellikler/ayarlar/gorunum/ayarlar_iletisim_bolumu.dart`
- `lib/ozellikler/ayarlar/gorunum/ayarlar_uygulama_bilgileri_bolumu.dart`
- `lib/ozellikler/ayarlar/gorunum/ayarlar_diger_uygulamalar_bolumu.dart`
- `lib/ozellikler/ayarlar/gorunum/ayarlar_destek_bolumu.dart`
- `lib/ozellikler/ayarlar/gorunum/ayarlar_biz_kimiz_bolumu.dart`
- `lib/ozellikler/ortak/gorunum/destek_ol_koprusu.dart`
- `lib/ozellikler/ortak/servisler/mesaj_servisi.dart`
- `lib/ozellikler/ortak/servisler/guncelleme_servisi.dart`
- `lib/uygulama/uygulama_yapilandirmasi.dart`
- `assets/about/M_BizKimiz.jpg`

## Birebirlik kapsami
- Akordeon renkleri
- Baslik metin tonu ve duzeni
- Acilis/kapanis davranislari (ExpansionTile + Destek bolumu animasyon stili)
- Mesaj gonderim ve son mesajlar akisi
- Guncelleme kontrol diyalog akisi

## Gerekli pubspec bagimliliklari
- `cloud_firestore`
- `firebase_auth`
- `firebase_core`
- `http`
- `package_info_plus`
- `shared_preferences`
- `url_launcher`

## Not
Bu klasor "kod sablonu"dur. Diger uygulamada ayni klasor yapisiyla kopyalanip kullanilmak uzere saklanmistir.

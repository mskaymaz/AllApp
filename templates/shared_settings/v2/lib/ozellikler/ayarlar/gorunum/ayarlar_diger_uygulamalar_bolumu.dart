import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../uygulama/uygulama_yapilandirmasi.dart';
import 'ayarlar_bilesenleri.dart';
import 'ayarlar_ortak_bolum_karti.dart';

class AyarlarDigerUygulamalarBolumu extends StatefulWidget {
  const AyarlarDigerUygulamalarBolumu({super.key});

  @override
  State<AyarlarDigerUygulamalarBolumu> createState() =>
      _AyarlarDigerUygulamalarBolumuState();
}

class _AyarlarDigerUygulamalarBolumuState
    extends State<AyarlarDigerUygulamalarBolumu> {
  late final Future<List<_DigerUygulamaKaydi>> _uygulamalarGelecegi;

  @override
  void initState() {
    super.initState();
    _uygulamalarGelecegi = _uygulamalariYukle();
  }

  @override
  Widget build(BuildContext context) {
    return AyarlarOrtakBolumKarti(
      baslik: 'Uygulamalarımız',
      baslikRengi: akordeonBaslikDigerUygulamalar,
      yardimMetni:
          'Bu bölüm MSK Labs tarafından hazırlanan mobil, masaüstü ve web uygulamalarını gruplu olarak listeler. Uygulama bağlantıları AllApp public kataloğundan okunur.',
      cocuk: Padding(
        padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
        child: FutureBuilder<List<_DigerUygulamaKaydi>>(
          future: _uygulamalarGelecegi,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<_DigerUygulamaKaydi>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final kayitlar = snapshot.data ?? const <_DigerUygulamaKaydi>[];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _KategoriListesi(
                  baslik: 'Mobil',
                  kayitlar: _kategoriyeGore(kayitlar, _UygulamaKategorisi.mobil),
                  ac: _uygulamaBaglantisiniAc,
                ),
                const SizedBox(height: 14),
                _KategoriListesi(
                  baslik: 'Masaüstü / Desktop',
                  kayitlar: _kategoriyeGore(
                    kayitlar,
                    _UygulamaKategorisi.masaustu,
                  ),
                  ac: _uygulamaBaglantisiniAc,
                ),
                const SizedBox(height: 14),
                _KategoriListesi(
                  baslik: 'Web',
                  kayitlar: _kategoriyeGore(kayitlar, _UygulamaKategorisi.web),
                  ac: _uygulamaBaglantisiniAc,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<_DigerUygulamaKaydi> _kategoriyeGore(
    List<_DigerUygulamaKaydi> kayitlar,
    _UygulamaKategorisi kategori,
  ) {
    return kayitlar
        .where((kayit) => kayit.kategori == kategori)
        .toList(growable: false);
  }

  Future<List<_DigerUygulamaKaydi>> _uygulamalariYukle() async {
    final uzakKayitlar = await _uzakKatalogYukle();
    if (uzakKayitlar.isNotEmpty) {
      return uzakKayitlar;
    }

    final yerelKayitlar = await _yerelKatalogYukle();
    if (yerelKayitlar.isNotEmpty) {
      return yerelKayitlar;
    }

    return _varsayilanKatalog();
  }

  Future<List<_DigerUygulamaKaydi>> _uzakKatalogYukle() async {
    final katalogUri = Uri.tryParse(
      UygulamaYapilandirmasi.digerUygulamalarKatalogBaglantisi.trim(),
    );
    if (katalogUri == null) {
      return const <_DigerUygulamaKaydi>[];
    }

    try {
      final yanit = await http.get(katalogUri).timeout(const Duration(seconds: 8));
      if (yanit.statusCode != 200) {
        return const <_DigerUygulamaKaydi>[];
      }
      return _kayitlariCoz(yanit.body);
    } catch (_) {
      return const <_DigerUygulamaKaydi>[];
    }
  }

  Future<List<_DigerUygulamaKaydi>> _yerelKatalogYukle() async {
    try {
      final payload = await rootBundle.loadString(
        UygulamaYapilandirmasi.yerelDigerUygulamalarKatalogYolu,
      );
      return _kayitlariCoz(payload);
    } catch (_) {
      return const <_DigerUygulamaKaydi>[];
    }
  }

  List<_DigerUygulamaKaydi> _kayitlariCoz(String payload) {
    try {
      final hamVeri = jsonDecode(payload);
      final kayitListesi = _hamKayitListesi(hamVeri);
      final kayitlar = <_DigerUygulamaKaydi>[];
      for (final kayit in kayitListesi) {
        if (kayit is! Map) continue;
        final cozulmus = _DigerUygulamaKaydi.fromJson(
          Map<String, dynamic>.from(kayit),
        );
        if (cozulmus != null &&
            cozulmus.hedefeUygunMu(UygulamaYapilandirmasi.uygulamaKodu)) {
          kayitlar.add(cozulmus);
        }
      }
      kayitlar.sort((a, b) => a.sira.compareTo(b.sira));
      return kayitlar;
    } catch (_) {
      return const <_DigerUygulamaKaydi>[];
    }
  }

  List<dynamic> _hamKayitListesi(dynamic hamVeri) {
    if (hamVeri is List<dynamic>) {
      return hamVeri;
    }
    if (hamVeri is Map<String, dynamic>) {
      final apps = hamVeri['apps'];
      if (apps is List<dynamic>) return apps;
      final items = hamVeri['items'];
      if (items is List<dynamic>) return items;
    }
    return const <dynamic>[];
  }

  List<_DigerUygulamaKaydi> _varsayilanKatalog() {
    return const <_DigerUygulamaKaydi>[
      _DigerUygulamaKaydi(
        uygulamaId: 'haydi_namaza',
        ad: 'Haydi Namaza',
        aciklama: 'Namaz vakti, kıble ve günlük içerik uygulaması',
        baglanti: 'https://github.com/mskaymaz/AllApp/tree/main/HaydiNamaza',
        ikonAsset: 'img/HaydiNamaza_icon.png',
        kategori: _UygulamaKategorisi.mobil,
        aktif: true,
        sira: 10,
        hedefUygulamalar: <String>['*'],
      ),
    ];
  }

  Future<void> _uygulamaBaglantisiniAc(String baglanti) async {
    final hedef = Uri.tryParse(baglanti.trim());
    if (hedef == null) {
      return;
    }

    final acildi = await launchUrl(
      hedef,
      mode: LaunchMode.externalApplication,
    );
    if (acildi || !mounted) {
      return;
    }

    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Bağlantı açılamadı.')));
  }
}

class _KategoriListesi extends StatelessWidget {
  const _KategoriListesi({
    required this.baslik,
    required this.kayitlar,
    required this.ac,
  });

  final String baslik;
  final List<_DigerUygulamaKaydi> kayitlar;
  final ValueChanged<String> ac;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          baslik,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        if (kayitlar.isEmpty)
          const _BosKategoriMetni()
        else
          ...kayitlar.map((kayit) => _UygulamaSatiri(kayit: kayit, ac: ac)),
      ],
    );
  }
}

class _UygulamaSatiri extends StatelessWidget {
  const _UygulamaSatiri({required this.kayit, required this.ac});

  final _DigerUygulamaKaydi kayit;
  final ValueChanged<String> ac;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white.withValues(alpha: 0.78),
      child: ListTile(
        dense: true,
        leading: _UygulamaIkonu(kayit: kayit),
        title: Text(kayit.ad),
        subtitle: kayit.aciklama.isEmpty ? null : Text(kayit.aciklama),
        trailing: const Icon(Icons.open_in_new_rounded, size: 18),
        onTap: () => ac(kayit.acilisBaglantisi),
      ),
    );
  }
}

class _UygulamaIkonu extends StatelessWidget {
  const _UygulamaIkonu({required this.kayit});

  final _DigerUygulamaKaydi kayit;

  @override
  Widget build(BuildContext context) {
    final asset = kayit.ikonAsset.trim();
    if (asset.isNotEmpty) {
      return Image.asset(
        asset,
        width: 42,
        height: 42,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _yedekIkon(context),
      );
    }

    return _yedekIkon(context);
  }

  Widget _yedekIkon(BuildContext context) {
    final trimmed = kayit.ad.trim();
    final initial = trimmed.isEmpty
        ? 'M'
        : String.fromCharCode(trimmed.runes.first).toUpperCase();
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0A800)),
      ),
      child: Text(
        initial,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF7A4F00),
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _BosKategoriMetni extends StatelessWidget {
  const _BosKategoriMetni();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: const Text('Bu kategori için henüz kayıt yok.'),
    );
  }
}

enum _UygulamaKategorisi { mobil, masaustu, web }

final class _DigerUygulamaKaydi {
  const _DigerUygulamaKaydi({
    required this.uygulamaId,
    required this.ad,
    required this.aciklama,
    required this.baglanti,
    required this.ikonAsset,
    required this.kategori,
    required this.aktif,
    required this.sira,
    required this.hedefUygulamalar,
    this.indirmeBaglantisi = '',
  });

  final String uygulamaId;
  final String ad;
  final String aciklama;
  final String baglanti;
  final String indirmeBaglantisi;
  final String ikonAsset;
  final _UygulamaKategorisi kategori;
  final bool aktif;
  final int sira;
  final List<String> hedefUygulamalar;

  String get acilisBaglantisi => indirmeBaglantisi.trim().isNotEmpty
      ? indirmeBaglantisi.trim()
      : baglanti.trim();

  static _DigerUygulamaKaydi? fromJson(Map<String, dynamic> veri) {
    final uygulamaId = _ilkMetin(veri, const ['app_id', 'appId', 'id']);
    final ad = _ilkMetin(veri, const ['name', 'ad']);
    final aciklama = _ilkMetin(veri, const ['description', 'aciklama']);
    final baglanti = _ilkMetin(veri, const ['url', 'baglanti']);
    final indirmeBaglantisi = _ilkMetin(
      veri,
      const ['download_url', 'downloadUrl', 'release_url', 'releaseUrl'],
    );
    final ikonAsset = _ilkMetin(veri, const ['icon_asset', 'iconAsset']);
    final kategoriMetni = _ilkMetin(
      veri,
      const ['category', 'kategori', 'platform', 'type'],
    );
    final aktif = (veri['active'] as bool?) ?? (veri['aktif'] as bool?) ?? true;
    final sira = (veri['order'] as num?)?.toInt() ??
        (veri['sira'] as num?)?.toInt() ??
        9999;
    final hedefUygulamalar = _hedefleriOku(veri);

    if (uygulamaId.isEmpty || ad.isEmpty || baglanti.isEmpty) {
      return null;
    }
    if (!_gecerliBaglantiMi(baglanti) ||
        (indirmeBaglantisi.isNotEmpty && !_gecerliBaglantiMi(indirmeBaglantisi))) {
      return null;
    }

    return _DigerUygulamaKaydi(
      uygulamaId: uygulamaId.toLowerCase(),
      ad: ad,
      aciklama: aciklama,
      baglanti: baglanti,
      indirmeBaglantisi: indirmeBaglantisi,
      ikonAsset: ikonAsset,
      kategori: _kategoriCoz(kategoriMetni),
      aktif: aktif,
      sira: sira,
      hedefUygulamalar: hedefUygulamalar,
    );
  }

  bool hedefeUygunMu(String uygulamaKodu) {
    if (!aktif) return false;
    final kod = uygulamaKodu.trim().toLowerCase();
    if (uygulamaId == kod) return false;
    if (hedefUygulamalar.isEmpty) return true;
    return hedefUygulamalar.contains('*') || hedefUygulamalar.contains(kod);
  }

  static String _ilkMetin(Map<String, dynamic> veri, List<String> anahtarlar) {
    for (final anahtar in anahtarlar) {
      final deger = veri[anahtar];
      if (deger is String && deger.trim().isNotEmpty) {
        return deger.trim();
      }
    }
    return '';
  }

  static List<String> _hedefleriOku(Map<String, dynamic> veri) {
    final ham = veri['target_apps'] ?? veri['targetApps'] ?? veri['hedefUygulamalar'];
    if (ham is! List<dynamic>) return const <String>[];
    return ham
        .whereType<String>()
        .map((deger) => deger.trim().toLowerCase())
        .where((deger) => deger.isNotEmpty)
        .toList(growable: false);
  }

  static bool _gecerliBaglantiMi(String baglanti) {
    final uri = Uri.tryParse(baglanti.trim());
    return uri != null && uri.hasScheme;
  }

  static _UygulamaKategorisi _kategoriCoz(String deger) {
    final normalized = deger.trim().toLowerCase();
    if (normalized == 'desktop' ||
        normalized == 'masaustu' ||
        normalized == 'masaüstü' ||
        normalized == 'windows' ||
        normalized == 'macos' ||
        normalized == 'linux') {
      return _UygulamaKategorisi.masaustu;
    }
    if (normalized == 'web' || normalized == 'site') {
      return _UygulamaKategorisi.web;
    }
    return _UygulamaKategorisi.mobil;
  }
}


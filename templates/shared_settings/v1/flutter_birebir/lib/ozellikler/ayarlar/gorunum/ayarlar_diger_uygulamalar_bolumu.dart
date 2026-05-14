import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../uygulama/uygulama_yapilandirmasi.dart';
import 'ayarlar_bilesenleri.dart';

class AyarlarDigerUygulamalarBolumu extends StatelessWidget {
  const AyarlarDigerUygulamalarBolumu({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ListTileTheme.merge(
          dense: true,
          minVerticalPadding: 0,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          child: ExpansionTile(
            dense: true,
            maintainState: true,
            collapsedBackgroundColor: akordeonBaslikDigerUygulamalar,
            backgroundColor: akordeonBaslikDigerUygulamalar,
            tilePadding: const EdgeInsets.only(right: 20),
            childrenPadding: EdgeInsets.zero,
            title: SizedBox(
              height: arayuzAyarlarBaslikSatiriYuksekligi,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Diğer Uygulamalarımız',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ),
            children: <Widget>[
              Container(
                color: akordeonIcerikYuzeyi,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FractionallySizedBox(
                      widthFactor: 0.7,
                      child: OutlinedButton.icon(
                        onPressed: () => _digerUygulamalariBilgiBalonuAc(context),
                        icon: const Icon(Icons.apps_rounded),
                        label: const Text('Listeyi Gör'),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _digerUygulamalariBilgiBalonuAc(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Diğer Uygulamalarımız'),
            content: SizedBox(
              width: 420,
              child: FutureBuilder<List<_DigerUygulamaKaydi>>(
                future: _uygulamalariYukle(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<_DigerUygulamaKaydi>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 140,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final kayitlar = snapshot.data ?? const <_DigerUygulamaKaydi>[];
                  if (kayitlar.isEmpty) {
                    return const Text(
                      'Henüz listelenecek uygulama bulunmuyor.',
                      textAlign: TextAlign.center,
                    );
                  }

                  return SizedBox(
                    height: 320,
                    child: ListView.separated(
                      itemCount: kayitlar.length,
                      separatorBuilder: (_, int index) => const Divider(height: 1),
                      itemBuilder: (BuildContext context, int index) {
                        final kayit = kayitlar[index];
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(kayit.ad),
                          subtitle: kayit.aciklama.isEmpty
                              ? null
                              : Text(kayit.aciklama),
                          trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                          onTap: () => _uygulamaBaglantisiniAc(
                            context,
                            kayit.baglanti,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<_DigerUygulamaKaydi>> _uygulamalariYukle() async {
    final katalogBaglantisi = UygulamaYapilandirmasi
        .digerUygulamalarKatalogBaglantisi
        .trim();
    final katalogUri = Uri.tryParse(katalogBaglantisi);
    if (katalogUri == null) {
      return _varsayilanKatalog();
    }

    try {
      final yanit = await http
          .get(katalogUri)
          .timeout(const Duration(seconds: 8));
      if (yanit.statusCode != 200) {
        return _varsayilanKatalog();
      }

      final hamVeri = jsonDecode(yanit.body);
      final kayitListesi = _hamKayitListesi(hamVeri);
      final kayitlar = <_DigerUygulamaKaydi>[];
      for (final kayit in kayitListesi) {
        if (kayit is! Map<String, dynamic>) {
          continue;
        }
        final cozulmus = _DigerUygulamaKaydi.fromJson(kayit);
        if (cozulmus != null &&
            cozulmus.hedefeUygunMu(UygulamaYapilandirmasi.uygulamaKodu)) {
          kayitlar.add(cozulmus);
        }
      }

      kayitlar.sort((a, b) => a.sira.compareTo(b.sira));
      if (kayitlar.isEmpty) {
        return _varsayilanKatalog();
      }
      return kayitlar;
    } catch (_) {
      return _varsayilanKatalog();
    }
  }

  List<dynamic> _hamKayitListesi(dynamic hamVeri) {
    if (hamVeri is List<dynamic>) {
      return hamVeri;
    }
    if (hamVeri is Map<String, dynamic>) {
      final apps = hamVeri['apps'];
      if (apps is List<dynamic>) {
        return apps;
      }
      final items = hamVeri['items'];
      if (items is List<dynamic>) {
        return items;
      }
    }
    return const <dynamic>[];
  }

  List<_DigerUygulamaKaydi> _varsayilanKatalog() {
    return const <_DigerUygulamaKaydi>[
      _DigerUygulamaKaydi(
        ad: 'M Rekat Sayar',
        aciklama: 'Namaz sayim ve kalibrasyon uygulamasi',
        baglanti: 'https://github.com/mskaymaz/M_RekatSay',
        aktif: true,
        sira: 10,
        hedefUygulamalar: <String>['*'],
      ),
    ];
  }

  Future<void> _uygulamaBaglantisiniAc(BuildContext context, String baglanti) async {
    final hedef = Uri.tryParse(baglanti.trim());
    if (hedef == null) {
      return;
    }

    final acildi = await launchUrl(
      hedef,
      mode: LaunchMode.externalApplication,
    );
    if (acildi || !context.mounted) {
      return;
    }

    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Bağlantı açılamadı.')));
  }
}

final class _DigerUygulamaKaydi {
  const _DigerUygulamaKaydi({
    required this.ad,
    required this.aciklama,
    required this.baglanti,
    required this.aktif,
    required this.sira,
    required this.hedefUygulamalar,
  });

  final String ad;
  final String aciklama;
  final String baglanti;
  final bool aktif;
  final int sira;
  final List<String> hedefUygulamalar;

  static _DigerUygulamaKaydi? fromJson(Map<String, dynamic> veri) {
    final ad = (veri['ad'] as String?)?.trim() ?? '';
    final aciklama = (veri['aciklama'] as String?)?.trim() ?? '';
    final baglanti = (veri['baglanti'] as String?)?.trim() ?? '';
    final aktif = (veri['aktif'] as bool?) ?? true;
    final sira = (veri['sira'] as num?)?.toInt() ?? 9999;

    final hedefUygulamalar = (veri['targetApps'] as List<dynamic>? ?? const <dynamic>[])
        .whereType<String>()
        .map((String deger) => deger.trim().toLowerCase())
        .where((String deger) => deger.isNotEmpty)
        .toList(growable: false);

    if (ad.isEmpty || baglanti.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(baglanti);
    if (uri == null || (!uri.hasScheme && !uri.hasAuthority)) {
      return null;
    }

    return _DigerUygulamaKaydi(
      ad: ad,
      aciklama: aciklama,
      baglanti: baglanti,
      aktif: aktif,
      sira: sira,
      hedefUygulamalar: hedefUygulamalar,
    );
  }

  bool hedefeUygunMu(String uygulamaKodu) {
    if (!aktif) {
      return false;
    }
    if (hedefUygulamalar.isEmpty) {
      return true;
    }
    final kod = uygulamaKodu.trim().toLowerCase();
    return hedefUygulamalar.contains('*') || hedefUygulamalar.contains(kod);
  }
}

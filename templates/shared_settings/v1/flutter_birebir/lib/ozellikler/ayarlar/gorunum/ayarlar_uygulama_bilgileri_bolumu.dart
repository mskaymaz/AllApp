import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ortak/servisler/guncelleme_servisi.dart';
import '../../../uygulama/uygulama_yapilandirmasi.dart';
import 'ayarlar_bilesenleri.dart';

class AyarlarUygulamaBilgileriBolumu extends StatefulWidget {
  const AyarlarUygulamaBilgileriBolumu({super.key});

  @override
  State<AyarlarUygulamaBilgileriBolumu> createState() =>
      _AyarlarUygulamaBilgileriBolumuState();
}

class _AyarlarUygulamaBilgileriBolumuState
    extends State<AyarlarUygulamaBilgileriBolumu> {
  late final Future<PackageInfo> _paketBilgisiGelecegi;
  final GuncellemeServisi _guncellemeServisi = GuncellemeServisi();
  bool _guncellemeKontrolEdiliyor = false;

  @override
  void initState() {
    super.initState();
    _paketBilgisiGelecegi = PackageInfo.fromPlatform();
  }

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
            collapsedBackgroundColor: akordeonBaslikUygulamaBilgi,
            backgroundColor: akordeonBaslikUygulamaBilgi,
            tilePadding: const EdgeInsets.only(right: 20),
            childrenPadding: EdgeInsets.zero,
            title: SizedBox(
              height: arayuzAyarlarBaslikSatiriYuksekligi,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Uygulama Bilgileri ve Güncelleme',
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
                child: FutureBuilder<PackageInfo>(
                  future: _paketBilgisiGelecegi,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<PackageInfo> snapshot,
                  ) {
                    final bilgi = snapshot.data;
                    final surum = bilgi == null
                        ? 'Bilinmiyor'
                        : '${bilgi.version} (${bilgi.buildNumber})';
                    final releaseEtiketi = UygulamaYapilandirmasi.surumEtiketi;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            'Teknik Bilgiler',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _bilgiSatiri(
                          'Uygulama',
                          UygulamaYapilandirmasi.uygulamaAdi,
                        ),
                        _bilgiSatiri('Sürüm', surum),
                        _bilgiSatiri('Release', releaseEtiketi),
                        _bilgiSatiri(
                          'Dağıtım Kanalı',
                          UygulamaYapilandirmasi.dagitimKanali,
                        ),
                        const SizedBox(height: 12),
                        FractionallySizedBox(
                          widthFactor: 0.7,
                          child: FilledButton.icon(
                            onPressed: _guncellemeKontrolEdiliyor
                                ? null
                                : () => unawaited(
                                      _guncellemeleriKontrolEt(context),
                                    ),
                            icon: _guncellemeKontrolEdiliyor
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.system_update_alt_rounded),
                            label: Text(
                              _guncellemeKontrolEdiliyor
                                  ? 'Kontrol Ediliyor...'
                                  : 'Güncellemeleri Kontrol Et',
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guncellemeleriKontrolEt(BuildContext context) async {
    final mesajYonetici = ScaffoldMessenger.maybeOf(context);
    if (_guncellemeKontrolEdiliyor) {
      return;
    }

    setState(() {
      _guncellemeKontrolEdiliyor = true;
    });

    mesajYonetici?.hideCurrentSnackBar();
    mesajYonetici?.showSnackBar(
      const SnackBar(content: Text('Güncellemeler kontrol ediliyor...')),
    );

    try {
      final yerelPaket = await PackageInfo.fromPlatform();
      final guncelleme = await _guncellemeServisi.guncellemeKontrolEt();
      if (!context.mounted) {
        return;
      }

      mesajYonetici?.hideCurrentSnackBar();
      if (guncelleme == null) {
        mesajYonetici?.showSnackBar(
          const SnackBar(content: Text('Yeni sürüm bulunamadı.')),
        );
        return;
      }

      final guncellemeBaglantisi = Uri.tryParse(guncelleme.url.trim());
      if (guncellemeBaglantisi == null) {
        return;
      }

      final onay = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Yeni Sürüm Hazır'),
            content: Text(
              'Mevcut sürüm: ${yerelPaket.version} (${yerelPaket.buildNumber})\n'
              'Yeni sürüm: ${guncelleme.version} (${guncelleme.buildNumber})\n\n'
              '${guncelleme.forceUpdate ? 'Bu güncelleme önerilir.' : 'İsterseniz şimdi güncelleyebilirsiniz.'}',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Daha Sonra'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Güncelle'),
              ),
            ],
          );
        },
      );

      if (onay != true || !context.mounted) {
        return;
      }

      await launchUrl(
        guncellemeBaglantisi,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      // Sessiz hata yonetimi: kullaniciya acik hata gostermiyoruz.
      return;
    } finally {
      if (mounted) {
        setState(() {
          _guncellemeKontrolEdiliyor = false;
        });
      }
    }
  }

  Widget _bilgiSatiri(String etiket, String deger) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(etiket)),
          Text(deger),
        ],
      ),
    );
  }
}

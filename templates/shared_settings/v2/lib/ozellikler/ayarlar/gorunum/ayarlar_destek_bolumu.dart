import 'dart:async';

import 'package:flutter/material.dart';

import '../../../alan_cekirdegi/servisler/oturum_denetleyicisi.dart';
import '../../ortak/gorunum/destek_ol_koprusu.dart';
import 'ayarlar_bilesenleri.dart';
import 'ayarlar_ortak_bolum_karti.dart';

class AyarlarDestekBolumu extends StatefulWidget {
  const AyarlarDestekBolumu({super.key, required this.oturumDenetleyicisi});

  final OturumDenetleyicisi oturumDenetleyicisi;

  @override
  State<AyarlarDestekBolumu> createState() => _AyarlarDestekBolumuState();
}

class _AyarlarDestekBolumuState extends State<AyarlarDestekBolumu> {
  int _acilisRevizyonu = destekOlAcilisRevizyonu.value;
  bool _acik = false;
  late final ExpansibleController _acilirDenetleyici;

  @override
  void initState() {
    super.initState();
    _acilirDenetleyici = ExpansibleController();
    destekOlAcilisRevizyonu.addListener(_destekOlKoprusunuDinle);
  }

  @override
  void dispose() {
    destekOlAcilisRevizyonu.removeListener(_destekOlKoprusunuDinle);
    _acilirDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.oturumDenetleyicisi,
      builder: (BuildContext context, Widget? child) {
        final sayimEtkin = widget.oturumDenetleyicisi.durum.sayimEtkin;
        return AyarlarOrtakBolumKarti(
          key: ValueKey<String>('destek_ol_$_acilisRevizyonu'),
          baslik: 'Destek Olabilirsiniz',
          baslikRengi: akordeonBaslikDestekOl,
          yardimMetni:
              'Bu bölüm uygulamaya destek ve dua hatırlatma alanıdır. Dua Ediyorum düğmesi yalnızca ekrandaki teşekkür mesajını gösterir.',
          acilirDenetleyici: _acilirDenetleyici,
          baslangictaAcik: _acik,
          animasyonStili: const AnimationStyle(
            duration: Duration(milliseconds: 650),
            curve: Curves.easeInOutCubic,
          ),
          acilmaDurumuDegisti: (bool acik) => setState(() => _acik = acik),
          cocuk: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 15),
              const _DestekOlKatmaniMetni(),
              const SizedBox(height: 12),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: FilledButton.icon(
                  onPressed: sayimEtkin ? null : () => _duaDesteginiKaydet(),
                  icon: const Icon(Icons.volunteer_activism_rounded),
                  label: const Text('Dua Ediyorum'),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  void _destekOlKoprusunuDinle() {
    final yeniRevizyon = destekOlAcilisRevizyonu.value;
    if (yeniRevizyon == _acilisRevizyonu || !mounted) {
      return;
    }
    setState(() {
      _acilisRevizyonu = yeniRevizyon;
      _acik = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          alignment: 0.14,
        ),
      );
    });
  }

  void _duaDesteginiKaydet() {
    final mesajYonetici = ScaffoldMessenger.maybeOf(context);
    mesajYonetici?.hideCurrentSnackBar();
    mesajYonetici?.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Color(0xFF2E7D32),
        content: SizedBox(
          width: double.infinity,
          child: Text(
            'Allah (cc) razı olsun.\nDuanız bizim için kıymetli.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
    _acilirDenetleyici.collapse();
  }
}

class _DestekOlKatmaniMetni extends StatelessWidget {
  const _DestekOlKatmaniMetni();

  @override
  Widget build(BuildContext context) {
    const yaziBoyutu = 18.0;
    const ortakYazi = TextStyle(height: 1.75, fontWeight: FontWeight.w500);
    final yaziRengi =
        Theme.of(context).textTheme.bodyMedium?.color ??
        Theme.of(context).colorScheme.onSurface;
    final inceYazi = ortakYazi.copyWith(
      fontSize: yaziBoyutu,
      color: yaziRengi,
      fontWeight: FontWeight.w300,
    );
    final kalinYazi = ortakYazi.copyWith(
      fontSize: yaziBoyutu,
      color: yaziRengi,
      fontWeight: FontWeight.w800,
    );
    return DefaultTextStyle(
      style: ortakYazi.copyWith(fontSize: yaziBoyutu, color: yaziRengi),
      textAlign: TextAlign.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text.rich(
            TextSpan(
              style: inceYazi,
              text: 'Öncelikle ',
              children: <InlineSpan>[
                TextSpan(text: 'Direniş', style: kalinYazi),
                const TextSpan(text: ' için,\n'),
                const TextSpan(text: 'tüm '),
                TextSpan(text: 'Dünya Müslümanları', style: kalinYazi),
                const TextSpan(text: ' için\nve '),
                TextSpan(text: 'bizim', style: kalinYazi),
                const TextSpan(text: ' için '),
                TextSpan(text: 'dua edin.', style: kalinYazi),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Allah (cc) hepimizden razı olsun.',
            style: ortakYazi.copyWith(fontSize: yaziBoyutu, color: yaziRengi),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


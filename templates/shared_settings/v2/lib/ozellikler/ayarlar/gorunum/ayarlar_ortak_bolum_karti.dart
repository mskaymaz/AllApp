import 'package:flutter/material.dart';

import 'ayarlar_bilesenleri.dart';

class AyarlarOrtakBolumKarti extends StatelessWidget {
  const AyarlarOrtakBolumKarti({
    super.key,
    required this.baslik,
    required this.baslikRengi,
    required this.cocuk,
    this.yardimMetni,
    this.baslangictaAcik = false,
    this.acilirDenetleyici,
    this.acilmaDurumuDegisti,
    this.animasyonStili,
  });

  final String baslik;
  final Color baslikRengi;
  final Widget cocuk;
  final String? yardimMetni;
  final bool baslangictaAcik;
  final ExpansibleController? acilirDenetleyici;
  final ValueChanged<bool>? acilmaDurumuDegisti;
  final AnimationStyle? animasyonStili;

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
            controller: acilirDenetleyici,
            dense: true,
            maintainState: true,
            initiallyExpanded: baslangictaAcik,
            expansionAnimationStyle: animasyonStili,
            collapsedBackgroundColor: baslikRengi,
            backgroundColor: baslikRengi,
            tilePadding: const EdgeInsets.only(right: 20),
            childrenPadding: EdgeInsets.zero,
            onExpansionChanged: acilmaDurumuDegisti,
            title: SizedBox(
              height: arayuzAyarlarBaslikSatiriYuksekligi,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, right: 36),
                      child: Text(
                        baslik,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                  if ((yardimMetni ?? '').trim().isNotEmpty)
                    Positioned(
                      right: -4,
                      top: 2,
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: AciklamaDugmesi(
                            metin: yardimMetni!,
                            tooltip: 'Yardım',
                            iconData: Icons.info_outline_rounded,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            children: <Widget>[
              Container(
                color: akordeonIcerikYuzeyi,
                width: double.infinity,
                child: cocuk,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


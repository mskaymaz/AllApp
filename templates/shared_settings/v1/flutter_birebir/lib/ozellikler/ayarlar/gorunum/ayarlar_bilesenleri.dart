import 'package:flutter/material.dart';

// Akordeon ve liste yüzeyleri için sabit renkler
const Color akordeonIcerikYuzeyi = Color(0xFFF4F4F4);
const Color akordeonBaslikGenel = Color(0xFFF6E6D1);
const Color akordeonBaslikBizeUlasin = Color(0xFFD7F0D1);
const Color akordeonBaslikUygulamaBilgi = Color(0xFFE6D5F0);
const Color akordeonBaslikBizKimiz = Color(0xFFE8E6CF);
const Color akordeonBaslikDigerUygulamalar = Color(0xFFF2D9E8);
const Color akordeonBaslikDestekOl = Color(0xFFD6E5F5);
const Color akordeonBaslikKalibrasyon = Color(0xFFDCE3F2);
const Color akordeonBaslikGelismis = Color(0xFFE4DED3);
const Color akordeonBaslikAdmin = Color(0xFFF2D0D0);
const Color acilirListeYuzeyi = Color(0xFFF7F2E9);
const Color acilirListeMenuYuzeyi = Color(0xFFF0E6D8);
const Color acilirListeSinirRengi = Color(0xFFDCCEB8);

const double standartAcilirListeKoseYariCapi = 14;
const double standartAcilirListeYuksekligi = 35;
const double standartAcilirListeGenisligi = 230;
const double standartAcilirListeSolIcPadding = 15;
const double standartAcilirListeYaziBoyutu = 17;
const double standartAcilirListeMenuItemYuksekligi = 30;
const double standartAcilirListeMenuDikeyKaydirma = -5;
const double standartYardimMenusuGenislikOrani = 0.6;
const double arayuzAyarlarBaslikSatiriYuksekligi = 35;

/// [AciklamaDugmesi], bilgi ve dikkat yardımlarını aynı popup davranışında toplar.
class AciklamaDugmesi extends StatelessWidget {
  const AciklamaDugmesi({super.key, required this.metin, required this.tooltip, required this.iconData});
  final String metin, tooltip;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        final box = context.findRenderObject() as RenderBox;
        final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
        final menuWidth = overlay.size.width * standartYardimMenusuGenislikOrani;
        final position = RelativeRect.fromRect(
          Rect.fromLTWH(box.localToGlobal(Offset.zero).dx - menuWidth + 20, box.localToGlobal(Offset.zero).dy + 30, menuWidth, 0),
          Offset.zero & overlay.size,
        );
        showMenu(
          context: context,
          position: position,
          color: acilirListeMenuYuzeyi,
          constraints: BoxConstraints.tightFor(width: menuWidth),
          items: [PopupMenuItem(enabled: false, child: Text(metin, style: const TextStyle(color: Colors.black)))],
        );
      },
      child: Tooltip(message: tooltip, child: Icon(iconData)),
    );
  }
}

class YardimAciklamasiDugmesi extends StatelessWidget {
  const YardimAciklamasiDugmesi({super.key, required this.metin});
  final String metin;
  @override
  Widget build(BuildContext context) => AciklamaDugmesi(metin: metin, tooltip: 'Uyarı', iconData: Icons.info_outline_rounded);
}

class DikkatAciklamasiDugmesi extends StatelessWidget {
  const DikkatAciklamasiDugmesi({super.key, required this.metin});
  final String metin;
  @override
  Widget build(BuildContext context) => AciklamaDugmesi(metin: metin, tooltip: 'Dikkat', iconData: Icons.warning_amber_rounded);
}

/// [StandartAcilirListeButonu], Ayarlar içindeki açılır liste tetiklerini sunar.
class StandartAcilirListeButonu<T> extends StatelessWidget {
  const StandartAcilirListeButonu({
    super.key,
    required this.seciliDeger,
    required this.secenekler,
    required this.etiket,
    required this.degerSecildi,
    this.yukseklik = standartAcilirListeYuksekligi,
    this.genislik = standartAcilirListeGenisligi,
    this.menuGenislik,
  });

  final T seciliDeger;
  final List<T> secenekler;
  final String Function(T) etiket;
  final ValueChanged<T> degerSecildi;
  final double yukseklik, genislik;
  final double? menuGenislik;

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(fontSize: standartAcilirListeYaziBoyutu, color: Colors.black);
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: genislik,
        height: yukseklik,
        child: Material(
          color: acilirListeYuzeyi,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(standartAcilirListeKoseYariCapi),
            side: const BorderSide(color: acilirListeSinirRengi),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(standartAcilirListeKoseYariCapi),
            onTap: () async {
              final box = context.findRenderObject() as RenderBox;
              final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
              final position = RelativeRect.fromRect(
                Rect.fromPoints(
                  box.localToGlobal(const Offset(0, standartAcilirListeMenuDikeyKaydirma), ancestor: overlay),
                  box.localToGlobal(box.size.bottomRight(const Offset(0, standartAcilirListeMenuDikeyKaydirma)), ancestor: overlay),
                ),
                Offset.zero & overlay.size,
              );
              final T? newValue = await showMenu<T>(
                context: context,
                position: position,
                initialValue: seciliDeger,
                color: acilirListeMenuYuzeyi,
                constraints: BoxConstraints.tightFor(width: menuGenislik ?? genislik),
                items: secenekler.map((T option) {
                  return PopupMenuItem<T>(
                    value: option,
                    height: standartAcilirListeMenuItemYuksekligi,
                    child: Text(etiket(option), style: textStyle),
                  );
                }).toList(),
              );
              if (newValue != null && newValue != seciliDeger) degerSecildi(newValue);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: standartAcilirListeSolIcPadding),
              child: Row(
                children: [
                  Expanded(child: Text(etiket(seciliDeger), overflow: TextOverflow.ellipsis, style: textStyle)),
                  const Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

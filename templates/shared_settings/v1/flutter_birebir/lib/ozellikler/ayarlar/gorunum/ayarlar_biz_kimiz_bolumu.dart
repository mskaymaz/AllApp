import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ayarlar_bilesenleri.dart';

class AyarlarBizKimizBolumu extends StatelessWidget {
  const AyarlarBizKimizBolumu({super.key});

  static final Uri _blogUrl = Uri.parse('https://msklabsdevelopment.blogspot.com');

  Future<void> _blogaGit(BuildContext context) async {
    final disTarayiciAcildi = await launchUrl(
      _blogUrl,
      mode: LaunchMode.externalApplication,
    );
    if (disTarayiciAcildi) {
      return;
    }

    final varsayilanAcildi = await launchUrl(
      _blogUrl,
      mode: LaunchMode.platformDefault,
    );
    if (varsayilanAcildi || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Baglanti acilamadi.')),
    );
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
            collapsedBackgroundColor: akordeonBaslikBizKimiz,
            backgroundColor: akordeonBaslikBizKimiz,
            tilePadding: const EdgeInsets.only(right: 20),
            childrenPadding: EdgeInsets.zero,
            title: SizedBox(
              height: arayuzAyarlarBaslikSatiriYuksekligi,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Biz Kimiz',
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
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: <Widget>[
                          Image.asset(
                            'img/M_BizKimiz.jpg',
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: const Alignment(0, 0.84),
                              child: FractionallySizedBox(
                                widthFactor: 0.90,
                                heightFactor: 0.05,
                                child: Material(
                                  color: Colors.yellow.withValues(alpha: 0.20),
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () => _blogaGit(context),
                                    borderRadius: BorderRadius.circular(10),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Rekat Sayar, namaz sayimini daha guvenli ve sade hale getirmek icin gelistirdigimiz kucuk bir ekip calismasidir.',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Gelen geri bildirimleri dikkate aliyor, uygulamayi gercek kullanim verileriyle adim adim iyilestiriyoruz. '
                        'Ek projelerimizi Ayarlar icindeki "Diger Uygulamalarimiz" bolumunden takip edebilirsiniz.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ayarlar_bilesenleri.dart';
import 'ayarlar_ortak_bolum_karti.dart';

class AyarlarBizKimizBolumu extends StatelessWidget {
  const AyarlarBizKimizBolumu({super.key});

  static final Uri _blogUrl = Uri.parse('https://msklabsdevelopment.blogspot.com');

  Future<void> _blogaGit(BuildContext context) async {
    final disTarayiciAcildi = await launchUrl(
      _blogUrl,
      mode: LaunchMode.externalApplication,
    );
    if (disTarayiciAcildi) return;

    final varsayilanAcildi = await launchUrl(
      _blogUrl,
      mode: LaunchMode.platformDefault,
    );
    if (varsayilanAcildi || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bağlantı açılamadı.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AyarlarOrtakBolumKarti(
      baslik: 'Hakkımızda',
      baslikRengi: akordeonBaslikBizKimiz,
      yardimMetni:
          'Bu bölüm uygulama ve MSK Labs hakkında kısa bilgi verir. Görsel üzerindeki blog alanına dokunarak proje blogunu açabilirsiniz.',
      cocuk: Padding(
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
                'RekatSay, namaz sayımını daha güvenli ve sade hale getirmek için geliştirdiğimiz küçük bir ekip çalışmasıdır.',
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Gelen geri bildirimleri dikkate alıyor, uygulamayı gerçek kullanım verileriyle adım adım iyileştiriyoruz. Ek projelerimizi Ayarlar içindeki "Uygulamalarımız" bölümünden takip edebilirsiniz.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}


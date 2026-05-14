import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import '../../../alan_cekirdegi/servisler/oturum_denetleyicisi.dart';
import '../../ortak/servisler/mesaj_servisi.dart';
import 'ayarlar_bilesenleri.dart';

class BizeUlasinKarti extends StatefulWidget {
  const BizeUlasinKarti({super.key, required this.oturumDenetleyicisi});
  final OturumDenetleyicisi oturumDenetleyicisi;
  @override
  State<BizeUlasinKarti> createState() => _BizeUlasinKartiState();
}

class _BizeUlasinKartiState extends State<BizeUlasinKarti> {
  static const String _destekEposta = 'msklabs.org@gmail.com';
  static const List<String> _konuBasliklari = <String>[
    'Oneri / Geri Bildirim',
    'Hata Bildirimi',
    'Talepler',
    'Diger',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final MesajServisi _mesajServisi = MesajServisi();
  StreamSubscription<List<KullaniciMesaji>>? _sonMesajAboneligi;
  List<KullaniciMesaji> _sonMesajlar = const [];
  String _selectedTopic = _konuBasliklari.first;
  bool _awaitingReply = false;
  bool _sending = false;
  bool _loadingMessages = false;

  @override
  void initState() {
    super.initState();
    _sonMesajlariDinle();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    unawaited(_sonMesajAboneligi?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        collapsedBackgroundColor: akordeonBaslikBizeUlasin,
        backgroundColor: akordeonBaslikBizeUlasin,
        title: const Text(
          'Bize Ulaşın',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        children: [
          Container(
            color: akordeonIcerikYuzeyi,
            padding: const EdgeInsets.fromLTRB(15, 14, 15, 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                Row(
                  children: [
                    Expanded(
                      child: StandartAcilirListeButonu<String>(
                        seciliDeger: _selectedTopic,
                        secenekler: _konuBasliklari,
                        etiket: (deger) => deger,
                        genislik: 185,
                        degerSecildi: (deger) {
                          setState(() => _selectedTopic = deger);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() => _awaitingReply = !_awaitingReply);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _awaitingReply,
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (deger) {
                                setState(() => _awaitingReply = deger ?? true);
                              },
                            ),
                            const Text('Cevap bekliyorum'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  maxLength: 80,
                  decoration: const InputDecoration(
                    labelText: 'Isim *',
                    border: OutlineInputBorder(),
                    isDense: true,
                    counterText: '',
                  ),
                  validator: _isimDogrula,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  maxLength: 254,
                  decoration: const InputDecoration(
                    labelText: 'E-posta *',
                    border: OutlineInputBorder(),
                    isDense: true,
                    counterText: '',
                  ),
                  validator: _epostaDogrula,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _messageController,
                  minLines: 4,
                  maxLines: 6,
                  maxLength: 300,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(300),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Mesajınız *',
                    helperText: 'En az 10 karakter',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: _mesajDogrula,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                      children: <InlineSpan>[
                        const TextSpan(text: 'Ayrıntılı isteklerinizi '),
                        TextSpan(
                          text: _destekEposta,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: ' adresinden bize ulaştırabilirsiniz.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(_sending ? 'Gönderiliyor...' : 'Gönder'),
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 10),
                _SonMesajlarListesi(
                  mesajlar: _sonMesajlar,
                  yukleniyor: _loadingMessages,
                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _sending = true);
    final packageInfo = await PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('anonymous_device_id');
    if (deviceId == null) {
      deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('anonymous_device_id', deviceId);
    }

    final sonuc = await _mesajServisi.mesajGonder(
      topic: _selectedTopic,
      senderName: _nameController.text.trim(),
      senderEmail: _emailController.text.trim().toLowerCase(),
      message: _messageController.text.trim(),
      replyContact: _emailController.text.trim().toLowerCase(),
      awaitingReply: _awaitingReply,
      appVersion: packageInfo.version,
      anonymousDeviceId: deviceId,
      isTestDevice: false,
      technicalSummary: {},
    );

    if (mounted) {
      setState(() => _sending = false);
      final mesajYonetici = ScaffoldMessenger.of(context);
      mesajYonetici.hideCurrentSnackBar();
      if (sonuc.basarili) {
        mesajYonetici.showSnackBar(
          const SnackBar(content: Text('Gönderildi')),
        );
        _messageController.clear();
        _nameController.clear();
        _emailController.clear();
      }
    }
  }

  String? _isimDogrula(String? deger) {
    final metin = deger?.trim() ?? '';
    if (metin.length < 2) return 'Isim en az 2 karakter olmali.';
    if (metin.length > 80) return 'Isim en fazla 80 karakter olabilir.';
    return null;
  }

  String? _epostaDogrula(String? deger) {
    final metin = deger?.trim().toLowerCase() ?? '';
    final gecerli = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(metin);
    if (!gecerli) return 'Gecerli bir e-posta girin.';
    if (metin.length > 254) return 'E-posta en fazla 254 karakter olabilir.';
    return null;
  }

  String? _mesajDogrula(String? deger) {
    final metin = deger?.trim() ?? '';
    if (metin.length < 10) return 'Mesaj en az 10 karakter olmali.';
    if (metin.length > 300) return 'Mesaj en fazla 300 karakter olabilir.';
    return null;
  }

  void _sonMesajlariDinle() {
    setState(() => _loadingMessages = true);
    _sonMesajAboneligi = _mesajServisi.sonMesajlariDinle().listen(
      (mesajlar) {
        if (!mounted) return;
        setState(() {
          _sonMesajlar = mesajlar;
          _loadingMessages = false;
        });
      },
      onError: (_) {
        if (!mounted) return;
        setState(() => _loadingMessages = false);
      },
    );
  }
}

class _SonMesajlarListesi extends StatelessWidget {
  const _SonMesajlarListesi({
    required this.mesajlar,
    required this.yukleniyor,
  });

  final List<KullaniciMesaji> mesajlar;
  final bool yukleniyor;

  @override
  Widget build(BuildContext context) {
    if (yukleniyor && mesajlar.isEmpty) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (mesajlar.isEmpty) {
      return const Text(
        'Henüz gönderilmiş mesaj yok.',
        style: TextStyle(fontSize: 13, color: Colors.black54),
      );
    }

    return SizedBox(
      height: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Gönderdiğiniz Mesajlar',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: mesajlar.length,
              itemBuilder: (BuildContext context, int index) {
                return _SonMesajKarti(mesaj: mesajlar[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SonMesajKarti extends StatelessWidget {
  const _SonMesajKarti({required this.mesaj});

  final KullaniciMesaji mesaj;

  @override
  Widget build(BuildContext context) {
    final tarih = mesaj.createdAt;
    final tarihMetni = tarih == null
        ? ''
        : '${tarih.day.toString().padLeft(2, '0')}.${tarih.month.toString().padLeft(2, '0')} ${tarih.hour.toString().padLeft(2, '0')}:${tarih.minute.toString().padLeft(2, '0')}';
    final adminGordu = mesaj.adminSeen || mesaj.status != 'new';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8D8D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  mesaj.topic,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (mesaj.awaitingReply) ...[
                const SizedBox(width: 8),
                const Text(
                  'Cevap bekleniyor',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
              const SizedBox(width: 8),
              Icon(
                adminGordu ? Icons.done_all_rounded : Icons.done_rounded,
                size: 16,
                color: adminGordu ? const Color(0xFF2E7D32) : Colors.black45,
              ),
              const SizedBox(width: 3),
              Text(
                adminGordu ? 'Goruldu' : 'Iletildi',
                style: TextStyle(
                  fontSize: 12,
                  color: adminGordu ? const Color(0xFF2E7D32) : Colors.black54,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                tarihMetni,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            mesaj.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (mesaj.adminReply != null && mesaj.adminReply!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3EA),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Cevap: ${mesaj.adminReply}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AdminMesajPaneliKarti extends StatefulWidget {
  const AdminMesajPaneliKarti({super.key});
  @override
  State<AdminMesajPaneliKarti> createState() => _AdminMesajPaneliKartiState();
}

class _AdminMesajPaneliKartiState extends State<AdminMesajPaneliKarti> {
  final _pinController = TextEditingController();
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        collapsedBackgroundColor: akordeonBaslikAdmin,
        backgroundColor: akordeonBaslikAdmin,
        title: const Text('Admin Mesaj Paneli'),
        children: [
          Container(
            color: akordeonIcerikYuzeyi,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (!_opened)
                  TextField(
                    controller: _pinController,
                    decoration: const InputDecoration(labelText: 'PIN'),
                  ),
                if (!_opened)
                  ElevatedButton(
                    onPressed: () => setState(() => _opened = true),
                    child: const Text('Aç'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

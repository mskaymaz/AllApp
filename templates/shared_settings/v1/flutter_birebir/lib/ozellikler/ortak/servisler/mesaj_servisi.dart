import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

final class MesajGonderSonucu {
  const MesajGonderSonucu({required this.basarili, this.hataMesaji});

  final bool basarili;
  final String? hataMesaji;
}

final class KullaniciMesaji {
  const KullaniciMesaji({
    required this.topic,
    required this.message,
    required this.status,
    required this.adminSeen,
    required this.awaitingReply,
    required this.createdAt,
    required this.adminReply,
  });

  final String topic;
  final String message;
  final String status;
  final bool adminSeen;
  final bool awaitingReply;
  final DateTime? createdAt;
  final String? adminReply;
}

/// [MesajServisi], "Bize Ulaşın" formundan gelen mesajları
/// Firestore 'contact_messages' koleksiyonuna güvenli bir şekilde iletir.
class MesajServisi {
  FirebaseFirestore? get _firestore =>
      Firebase.apps.isEmpty ? null : FirebaseFirestore.instance;
  FirebaseAuth? get _auth => Firebase.apps.isEmpty ? null : FirebaseAuth.instance;

  /// Mesajı Firestore'a gönderir.
  /// Başarılıysa true, hata durumunda false döner.
  Future<MesajGonderSonucu> mesajGonder({
    required String topic,
    required String senderName,
    required String senderEmail,
    required String message,
    required String replyContact,
    required bool awaitingReply,
    required String appVersion,
    required String anonymousDeviceId,
    required bool isTestDevice,
    required Map<String, dynamic> technicalSummary,
  }) async {
    try {
      final firestore = _firestore;
      final auth = _auth;
      if (firestore == null || auth == null) {
        return const MesajGonderSonucu(basarili: false);
      }

      final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
      if (user == null) {
        return const MesajGonderSonucu(
          basarili: false,
          hataMesaji: 'Oturum acilamadi',
        );
      }

      final DocumentReference doc = await firestore.collection('contact_messages').add({
        'topic': topic,
        'sender_name': senderName,
        'sender_email': senderEmail,
        'message': message,
        'reply_contact': replyContact,
        'awaiting_reply': awaitingReply,
        'app_version': appVersion,
        'os_version': Platform.operatingSystemVersion,
        'device_model': Platform.isAndroid ? 'Android' : Platform.operatingSystem,
        'language': Platform.localeName.split('_')[0],
        'created_at': FieldValue.serverTimestamp(), // Sunucu saati kullanımı
        'anonymous_device_id': anonymousDeviceId,
        'is_test_device': isTestDevice,
        'owner_uid': user.uid,
        'status': 'new', // Lifecycle starts with 'new'
        'technical_summary': technicalSummary,
      });
      
      return MesajGonderSonucu(
        basarili: doc.id.isNotEmpty,
        hataMesaji: doc.id.isEmpty ? 'Firestore belge id olusturmadi' : null,
      );
    } catch (e, stackTrace) {
      debugPrint('Mesaj gonderilemedi: $e');
      debugPrintStack(stackTrace: stackTrace);
      return MesajGonderSonucu(basarili: false, hataMesaji: e.toString());
    }
  }

  Future<List<KullaniciMesaji>> sonMesajlariGetir({int limit = 5}) async {
    final firestore = _firestore;
    final auth = _auth;
    if (firestore == null || auth == null) return const [];

    final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
    if (user == null) return const [];

    final snapshot = await firestore
        .collection('contact_messages')
        .where('owner_uid', isEqualTo: user.uid)
        .get();

    final mesajlar = <KullaniciMesaji>[];
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final cevapSnapshot = await doc.reference.collection('admin_replies').get();
      final cevaplar = cevapSnapshot.docs.toList()
        ..sort((a, b) {
          final aTarih = (a.data()['created_at'] as Timestamp?)?.toDate() ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final bTarih = (b.data()['created_at'] as Timestamp?)?.toDate() ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return bTarih.compareTo(aTarih);
        });
      final cevapData = cevaplar.isEmpty ? null : cevaplar.first.data();
      mesajlar.add(KullaniciMesaji(
        topic: data['topic'] as String? ?? 'Genel',
        message: data['message'] as String? ?? '',
        status: data['status'] as String? ?? 'new',
        adminSeen: data['admin_seen'] as bool? ?? false,
        awaitingReply: data['awaiting_reply'] as bool? ?? false,
        createdAt: (data['created_at'] as Timestamp?)?.toDate(),
        adminReply: (data['last_admin_reply'] as String?) ??
            (cevapData?['message'] as String?),
      ));
    }
    mesajlar.sort((a, b) {
      final aTarih = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTarih = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTarih.compareTo(aTarih);
    });
    return mesajlar.take(limit).toList();
  }

  Stream<List<KullaniciMesaji>> sonMesajlariDinle({int limit = 5}) async* {
    final firestore = _firestore;
    final auth = _auth;
    if (firestore == null || auth == null) {
      yield const [];
      return;
    }

    final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
    if (user == null) {
      yield const [];
      return;
    }

    yield* firestore
        .collection('contact_messages')
        .where('owner_uid', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      final mesajlar = <KullaniciMesaji>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        mesajlar.add(KullaniciMesaji(
          topic: data['topic'] as String? ?? 'Genel',
          message: data['message'] as String? ?? '',
          status: data['status'] as String? ?? 'new',
          adminSeen: data['admin_seen'] as bool? ?? false,
          awaitingReply: data['awaiting_reply'] as bool? ?? false,
          createdAt: (data['created_at'] as Timestamp?)?.toDate(),
          adminReply: data['last_admin_reply'] as String?,
        ));
      }
      mesajlar.sort((a, b) {
        final aTarih = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTarih = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTarih.compareTo(aTarih);
      });
      return mesajlar.take(limit).toList();
    });
  }
}

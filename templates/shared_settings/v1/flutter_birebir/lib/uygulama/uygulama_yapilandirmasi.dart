import 'package:flutter/material.dart';

/// `UygulamaYapilandirmasi`, ortak calisma kurallarini tek yerde toplar;
/// dil listesi ve tablet kirilimi gibi paylasilan kararlar burada kullanilir.
final class UygulamaYapilandirmasi {
  const UygulamaYapilandirmasi._();

  static const String uygulamaAdi = 'Rekat Sayar';
  static const String uygulamaKodu = String.fromEnvironment(
    'APP_CODE',
    defaultValue: 'rekat_sayar',
  );
  static const String surumEtiketi = String.fromEnvironment(
    'RELEASE_TAG',
    defaultValue: '-',
  );
  static const String dagitimKanali = String.fromEnvironment(
    'RELEASE_CHANNEL',
    defaultValue: 'public',
  );
  static const String guncellemeApkBaglantisi = String.fromEnvironment(
    'UPDATE_APK_URL',
    defaultValue: '',
  );
  static const String geriBildirimPaylasimBaglantisi = String.fromEnvironment(
    'SUPPORT_SHARE_URL',
    defaultValue: '',
  );
  static const String digerUygulamalarKatalogBaglantisi = String.fromEnvironment(
    'APP_CATALOG_URL',
    defaultValue:
        'https://raw.githubusercontent.com/mskaymaz/AllApp/main/app_catalog.json',
  );
  static const bool analizVeriToplamaEtkin = bool.fromEnvironment(
    'ANALYSIS_COLLECTION_ENABLED',
    defaultValue: true,
  );
  static const String analizVeriToplamaSonTarih = String.fromEnvironment(
    'ANALYSIS_COLLECTION_UNTIL_ISO',
    defaultValue: '',
  );

  static const String destekFormBaglantisi = String.fromEnvironment(
    'SUPPORT_FORM_URL',
    defaultValue:
        'https://docs.google.com/forms/d/e/1FAIpQLSep01YmzAoAYMWsmkqKnXKUn5hI1bb0rtJ9-B4uDy34LmeM3Q/formResponse',
  );
  static const String destekFormKonuAlanId = String.fromEnvironment(
    'SUPPORT_TOPIC',
    defaultValue: 'entry.444614572',
  );
  static const String destekFormMesajAlanId = String.fromEnvironment(
    'SUPPORT_MESSAGE',
    defaultValue: 'entry.161743202',
  );
  static const String destekFormOlusturmaAlanId = String.fromEnvironment(
    'SUPPORT_CREATED_AT',
    defaultValue: 'entry.957160348',
  );
  static const String destekFormMetaAlanId = String.fromEnvironment(
    'SUPPORT_METADATA',
    defaultValue: 'entry.1669460606',
  );
  static const String destekFormCevapIletisimAlanId = String.fromEnvironment(
    'SUPPORT_CONTACT',
    defaultValue: 'entry.871851023',
  );
  static const String destekFormUygulamaSurumuAlanId = String.fromEnvironment(
    'SUPPORT_APP_VERSION',
    defaultValue: 'entry.1951910134',
  );
  static const String destekFormCihazModeliAlanId = String.fromEnvironment(
    'SUPPORT_DEVICE_MODEL',
    defaultValue: 'entry.1806191017',
  );
  static const String destekFormIsletimSistemiAlanId = String.fromEnvironment(
    'SUPPORT_OS',
    defaultValue: 'entry.2049709221',
  );
  static const String destekFormDilAlanId = String.fromEnvironment(
    'SUPPORT_LANGUAGE',
    defaultValue: 'entry.1808820979',
  );

  static const String kalibrasyonFormBaglantisi = String.fromEnvironment(
    'CALIBRATION_FORM_URL',
    defaultValue:
        'https://docs.google.com/forms/d/e/1FAIpQLSe8xA43TxXyxs3x9a9kTKCEg_Nlgk2Oog-0QyfMPqxSaepBgQ/formResponse',
  );
  static const String kalibrasyonFormKonuAlanId = String.fromEnvironment(
    'CALIBRATION_TOPIC',
    defaultValue: 'entry.1341340431',
  );
  static const String kalibrasyonFormMesajAlanId = String.fromEnvironment(
    'CALIBRATION_MESSAGE',
    defaultValue: 'entry.1183002477',
  );
  static const String kalibrasyonFormOlusturmaAlanId = String.fromEnvironment(
    'CALIBRATION_CREATED_AT',
    defaultValue: 'entry.1879389793',
  );
  static const String kalibrasyonFormMetaAlanId = String.fromEnvironment(
    'CALIBRATION_METADATA',
    defaultValue: 'entry.633703365',
  );

  static const double tabletKirilimi = 840;
  static const bool demoBuild = bool.fromEnvironment(
    'DEMO_BUILD',
    defaultValue: false,
  );

  /// `destekModulleriEtkin`, Ayarlar icindeki Destek Modulleri kartinin
  /// urun yuzeyinde gorunup gorunmeyecegini merkezi olarak belirler.
  static const bool destekModulleriEtkin = bool.fromEnvironment(
    'DESTEK_MODULLERI_ETKIN',
    defaultValue: false,
  );
  static const Locale varsayilanDil = Locale('tr');
  static const List<Locale> desteklenenDiller = <Locale>[Locale('tr')];
}


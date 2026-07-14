# AllApp Shared Settings Template v2

Bu sürüm, MSK Labs uygulamalarında kullanılacak ortak ayarlar sözleşmesinin kanonik sürümüdür.

## Standart bölümler

1. Hakkımızda
2. Uygulama Bilgileri ve Güncelleme
3. Uygulamalarımız
4. Destek Olabilirsiniz

`Bize Ulaşın`, Hakkımızda bölümünün içindeki iletişim kartıdır. Böylece dört ana bölüm bütün uygulamalarda aynı kalır; uygulamaya özgü destek davranışı ise config veya uygulama uzantısı olarak tanımlanır.

## Klasör sözleşmesi

- `schemas/`: doğrulanabilir JSON sözleşmeleri
- `examples/`: yeni uygulama için kopyalanıp uyarlanacak örnek payload'lar
- `assets/`: şablon görselleri
- `lib/`: Flutter için görsel referans; doğrudan kopyalanmadan önce uygulamanın config, servis ve oturum katmanına uyarlanmalıdır

Çalışan uygulamalardaki ortak runtime katmanı şu sorumlulukları taşımalıdır:

- app config değerlerini tek bir yerde toplamak,
- uzak katalog/manifest verisini okumak,
- uzak veri alınamazsa yerel asset'e dönmek,
- uygulama kataloğunu `target_apps` ve `active` alanlarına göre filtrelemek,
- güncellemeyi semantic sürüm yerine build number ile karşılaştırmak,
- uygulamaya özel metin ve aksiyonları ortak UI koduna gömmemek.

## Yeni uygulamaya alma

1. `schemas/` altındaki sözleşmeleri kopyalayın.
2. `examples/shared_settings.config.example.json` dosyasını uygulama bilgileriyle doldurun.
3. Config'i uygulamanın tek bir `SharedSettingsAppConfig` nesnesine map edin.
4. `app_catalog.json` ve `update_manifest.json` için uzak adresleri ve yerel asset yedeklerini tanımlayın.
5. `lib/` altındaki Flutter referansını, uygulamanın kendi oturum, tema ve navigasyon katmanına bağlayın.
6. Uzak bağlantı başarısızken yerel katalog/manifest fallback'ini test edin.
7. Uygulamaya özel destek aksiyonu gerekiyorsa bunu config'teki aksiyon türüyle veya küçük bir uygulama uzantısıyla sağlayın.

## Uyum kuralları

- `app_id`: küçük harfli ASCII, boşluksuz ve kalıcı olmalıdır.
- `platform`: yalnızca `mobile`, `desktop` veya `web` olmalıdır.
- URL alanları geçerli `https` bağlantıları olmalıdır.
- `target_apps: ["*"]`, kaydın bütün uygulamalarda görünmesi demektir.
- Uygulama kendi kataloğunda listelenebilir; runtime mevcut uygulamanın kaydını göstermemelidir.
- Uzak dosya bozuksa veya ağ yoksa yerel dosya kullanılmalıdır.

Bu klasör runtime bağımlılığı değildir; AllApp sözleşme ve referans deposudur.

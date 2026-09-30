# PRODUCT_ARCHITECTURE_PRINCIPLES.md

## Amaç

Bu belge, yeni bir uygulama veya yazılım projesine başlarken teknoloji, mimari ve platform seçimlerinin hangi temel prensiplere göre yapılacağını tanımlar.

Yeni bir projeye başlarken bu belge referans alınmalı; teknoloji seçimi mevcut alışkanlıklara, öğrenme kolaylığına veya tek dil/tek framework kullanma isteğine göre otomatik yapılmamalıdır.

Başlangıç sorusu şudur:

> **Hayal edebileceğimiz en iyi ürünü; görsellik, performans, işlevsellik, ölçeklenebilirlik ve uzun vadeli sürdürülebilirlik açısından en az kısıtlamayla hangi teknoloji ve mimari gerçekleştirebilir?**

Bu belge bir teknoloji zorunluluğu değildir. Her yeni proje kendi ihtiyaçlarına göre ayrıca değerlendirilmelidir.

---

## 1. Temel Ürün Vizyonu

Hedef, yalnızca çalışan veya “yeterince iyi” uygulamalar geliştirmek değildir.

Hedef:

- Görsellik ve estetikte mümkün olan en üst seviyeyi hedeflemek.
- Kullanıcı deneyiminde profesyonel ürünlerle rekabet etmek.
- Performans, kararlılık ve kaynak kullanımında yüksek kalite sağlamak.
- Motor/core ve genel yazılım mimarisini profesyonel ölçekte tasarlamak.
- Teknoloji seçimlerinin gelecekte ürün vizyonunu engellememesini sağlamak.
- Gerektiğinde milyonlarca kullanıcıya veya büyük kod tabanlarına ölçeklenebilecek yapılar kurmak.
- Platforma özgü güçlü özelliklerden gerektiğinde yararlanmak.
- AI geliştirme ajanlarını (Codex, Copilot vb.) aktif geliştirme araçları olarak kabul etmek.

Teknoloji seçiminde artık ana kriter:

> **“Hangisini öğrenmek veya yazmak daha kolay?” değil, “Hangisi nihai ürünü en iyi şekilde gerçekleştirebilir?”**

---

## 2. Platform Stratejisi

Her şeyi tek bir programlama dili veya framework ile geliştirmek zorunlu değildir.

Ana yaklaşım:

> **Best experience everywhere, shared architecture underneath.**

Yani:

- Her platformda mümkün olan en iyi kullanıcı deneyimi hedeflenir.
- Gerektiğinde farklı platformlarda farklı frontend teknolojileri kullanılır.
- Platformların altında ortak veri modeli, API sözleşmeleri, kimlik sistemi, senkronizasyon protokolü ve iş kuralları bulunur.
- “Write once, run everywhere” yalnızca kalite kaybına yol açmıyorsa tercih edilir.
- Kod tekrarını azaltmak, kullanıcı deneyimi ve teknik kaliteyi düşürmekten daha önemli değildir.

---

## 3. Varsayılan Teknoloji Adayları

Bu liste otomatik seçim değildir. Yeni proje başında gereksinimlere göre yeniden değerlendirilmelidir.

### Mobil

**Birincil aday: Flutter + Dart**

Uygun olduğu alanlar:

- Android
- iOS
- Tablet
- Yüksek derecede özel UI
- Animasyonlu ve görsel olarak özgün uygulamalar
- Ortak mobil kod tabanı

Mobil uygulamalarda varsayılan ilk değerlendirme Flutter üzerinden yapılır.

Ancak platforma özgü kritik ihtiyaçlar Flutter'ı sınırlıyorsa native çözümler de değerlendirilmelidir.

---

### Masaüstü

**Birincil güçlü aday: Qt Quick/QML + C++**

Özellikle:

- Maksimum görsel özgürlük
- Özel ve sıra dışı masaüstü UI
- Animasyonlar
- Çoklu pencere yapıları
- Frameless/transparan pencereler
- System tray
- Always-on-top
- İşletim sistemi entegrasyonu
- Yüksek performans
- Windows/macOS/Linux hedefleri

gerektiren uygulamalarda ilk ciddi adaydır.

Genel ayrım:

- **QML / Qt Quick:** Görsel katman ve kullanıcı deneyimi
- **C++:** Core/motor, yüksek performans ve işletim sistemi entegrasyonu

Qt kullanılacak ticari projelerde lisanslama modeli proje başında ayrıca değerlendirilmelidir.

---

### Alternatif Masaüstü

**Tauri + Rust + React/TypeScript**

Özellikle:

- Web ve masaüstü deneyiminin yakın olduğu ürünlerde
- Web teknolojilerinin görsel esnekliğinden yararlanmak istendiğinde
- Rust tabanlı güçlü ve hafif backend/core gerektiğinde

ciddi adaydır.

Masaüstü uygulaması seçilirken Qt/QML ile Tauri/Rust yaklaşımı ürünün gerçek ihtiyaçlarına göre karşılaştırılmalıdır.

---

### Web

**Birincil aday: TypeScript + React + Next.js**

Özellikle:

- Modern web uygulamaları
- Responsive UI
- PWA
- SEO gereken yapılar
- HTML/CSS/SVG/Canvas/WebGL tabanlı yüksek görsel özgürlük
- Büyük frontend ekosistemi

için varsayılan güçlü adaydır.

Web uygulaması yalnızca kod paylaşımı amacıyla Flutter Web'e zorlanmamalıdır. Ürünün niteliğine göre ayrıca değerlendirme yapılmalıdır.

---

## 4. Core / Motor Stratejisi

Karmaşık veya çok platformlu ürünlerde UI ile iş mantığı mümkün olduğunca doğru sınırlarla ayrılmalıdır.

Değerlendirilecek ana teknolojiler:

- **Rust:** Güvenlik, performans, concurrency, networking ve uzun ömürlü core sistemler.
- **C++:** Native performans, Qt entegrasyonu, işletim sistemi ve düşük seviye sistem erişimi.
- **Go:** Network servisleri, backend servisleri ve operasyonel sadelik.
- **TypeScript/Node.js:** Web ağırlıklı servisler ve hızlı ürün geliştirme.
- **Python:** AI, veri işleme, otomasyon, tooling, script ve prototipleme.

Python yalnızca kolay öğrenildiği için ana ürün teknolojisi olarak seçilmemelidir.

Ancak uygun olduğu alanlarda kullanılmaya devam edilmelidir.

---

## 5. Çok Platformlu Ürün Mimarisi

Örnek genel yapı:

```text
                  Cloud / Sync / Backend
                           |
              API + Realtime + Authentication
                           |
          Shared Protocol + Shared Data Model
                           |
        +------------------+------------------+
        |                  |                  |
     Desktop             Mobile              Web
   Qt/QML+C++           Flutter        React/Next.js
        |                  |                  |
        +------------------+------------------+
                           |
                   Shared Product Logic
```

Her ürünün tüm bu katmanlara ihtiyacı olmayabilir.

Mimari, ürünün gerçek gereksinimlerine göre sadeleştirilmelidir.

---

## 6. Veri ve İletişim İçin Varsayılan Adaylar

İhtiyaca göre değerlendirilecek teknolojiler:

- **Sunucu veritabanı:** PostgreSQL
- **Yerel veri:** SQLite
- **Gerçek zamanlı iletişim:** WebSocket
- **P2P iletişim:** Gerektiğinde WebRTC
- **API:** REST
- **Yüksek performanslı servis iletişimi:** Gerektiğinde gRPC

Bu seçimler proje gereksinimi doğrulanmadan otomatik uygulanmamalıdır.

---

## 7. Design System Yaklaşımı

Farklı platformlarda farklı UI teknolojileri kullanılsa bile ürünün kimliği ortak olmalıdır.

Ortaklaştırılabilecek yapılar:

- Renk sistemi
- Tipografi
- Spacing
- Radius
- İkonografi
- Animasyon dili
- Motion prensipleri
- Component davranışları
- Erişilebilirlik kuralları

Bunlar mümkün olduğunca ortak **Design Tokens** üzerinden tanımlanmalıdır.

Ama her platformun doğal kullanıcı deneyimine gerektiğinde uyum sağlanmalıdır.

Amaç her platformda piksel piksel aynı UI değil, aynı ürün kimliğini taşıyan en iyi platform deneyimidir.

---

## 8. Yeni Proje Başlangıç Karar Süreci

Yeni bir uygulama başlatılırken kod yazılmadan önce şu sorular cevaplanmalıdır:

1. Bu ürün tam olarak nedir?
2. Ana hedef platform veya platformlar hangileridir?
3. Görsel kalite hedefi nedir?
4. En zor teknik gereksinimler nelerdir?
5. İşletim sistemiyle ne kadar derin entegrasyon gerekir?
6. Performans ve kaynak tüketimi ne kadar kritiktir?
7. Offline çalışma gerekiyor mu?
8. Cihazlar arası senkronizasyon gerekiyor mu?
9. Gerçek zamanlı iletişim gerekiyor mu?
10. Güvenlik ve gizlilik seviyesi nedir?
11. Kullanıcı ölçeği ne olabilir?
12. Beş yıl sonra bu teknoloji ürünü sınırlar mı?
13. Seçilen teknoloji AI geliştirme ajanlarıyla verimli şekilde sürdürülebilir mi?
14. Platformlar arasında hangi kod gerçekten paylaşılmalı?
15. Hangi bölümlerde platforma özel teknoloji kullanmak daha kaliteli sonuç verir?

Bu sorular cevaplanmadan yalnızca önceki projelerde kullanıldığı için bir teknoloji seçilmemelidir.

---

## 9. Karar İlkesi

Teknoloji seçiminde öncelik sırası genel olarak:

1. Ürün vizyonunu gerçekleştirme kapasitesi
2. Kullanıcı deneyimi ve görsel özgürlük
3. Performans ve kararlılık
4. Teknik yetenek ve platform entegrasyonu
5. Mimari kalite ve ölçeklenebilirlik
6. Uzun vadeli sürdürülebilirlik
7. Güvenlik
8. Ekosistem ve araç desteği
9. AI ajanlarıyla geliştirilebilirlik
10. Geliştirme hızı ve maliyet

Kolay öğrenilmesi tek başına belirleyici kriter değildir.

---

## 10. AI Ajanlarına Talimat

Bu belge Codex, Copilot veya başka bir AI geliştirme ajanına verildiğinde şu şekilde yorumlanmalıdır:

> Yeni projede teknoloji seçimini otomatik olarak mevcut projelerden kopyalama.
>
> Önce ürün gereksinimlerini analiz et.
>
> Görsellik, performans, kullanıcı deneyimi, mimari kalite, platform entegrasyonu, güvenlik, ölçeklenebilirlik ve uzun vadeli sürdürülebilirliği birlikte değerlendir.
>
> Gerekirse farklı platformlar için farklı frontend teknolojileri öner.
>
> Tek kod tabanı uğruna ürün kalitesinden taviz verme.
>
> Önerilen teknolojilerin avantajlarını, dezavantajlarını ve uzun vadeli risklerini açıkça belirt.
>
> Kullanıcının mevcut bilgi seviyesini veya bir teknolojinin kolay öğrenilmesini birincil karar kriteri yapma.
>
> Nihai seçim yapılmadan önce en güçlü 2-3 mimari alternatifi karşılaştır.
>
> Gereksiz overengineering yapma. Ürünün gerçek ihtiyaçlarını aşan karmaşıklık ekleme.
>
> Ama gelecekte bilinen gereksinimler varsa, kısa vadeli kolaylık uğruna mimari çıkmaz oluşturma.

---

## 11. Yeni Projeye Başlarken Kullanılacak Giriş

Yeni bir uygulama için ChatGPT, Codex veya başka bir AI ajanıyla çalışmaya başlarken aşağıdaki giriş kullanılabilir:

> **Bu proje için PRODUCT_ARCHITECTURE_PRINCIPLES.md belgesindeki genel yazılım mimarisi ve teknoloji seçim prensiplerini esas al. Ancak belgede geçen teknolojileri otomatik olarak seçme. Önce bu uygulamanın gerçek gereksinimlerini benimle birlikte analiz et. Görsellik ve estetikte maksimum özgürlük, yüksek performans, profesyonel mimari, işlevsellik, güvenlik, ölçeklenebilirlik ve uzun vadeli sürdürülebilirlik hedeflerimiz var. Öğrenmesi kolay olduğu için daha zayıf bir teknoloji seçme; aynı şekilde gereksiz karmaşıklık da oluşturma. Mobil, masaüstü, web, backend ve core ihtiyaçlarını ayrı ayrı değerlendir. Gerekirse her platform için en uygun teknolojiyi seç. Önce en güçlü mimari alternatifleri artı ve eksileriyle karşılaştır, sonra benimle istişare ederek nihai teknoloji yığınını belirle. Kodlamaya ancak bu karar netleştikten sonra geç.**

---

## 12. Mevcut Genel Referans Kararı

Bugünkü genel değerlendirmeye göre başlangıç referansımız:

- **Mobil:** Flutter + Dart
- **Masaüstü:** Qt Quick/QML + C++ veya ürüne göre Tauri + Rust + React/TypeScript
- **Web:** TypeScript + React + Next.js
- **Yüksek performanslı Core:** Rust veya C++
- **Backend:** Rust veya Go; ihtiyaca göre TypeScript/Node.js
- **Sunucu veritabanı:** PostgreSQL
- **Yerel veri:** SQLite
- **Realtime:** WebSocket
- **P2P:** Gerektiğinde WebRTC
- **Platformlar arası görsel kimlik:** Ortak Design System + Design Tokens

Bu liste nihai ve değişmez bir standart değildir.

Her yeni proje için temel prensip şudur:

> **Önce ürünü ve hedefleri tanımla. Sonra o ürünü en az kısıtlayan ve en yüksek kaliteye ulaştırabilecek teknoloji mimarisini seç.**

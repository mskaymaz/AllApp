import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import '../../../uygulama/uygulama_yapilandirmasi.dart';

class GuncellemeBilgisi {
  final String version;
  final int buildNumber;
  final String url;
  final bool forceUpdate;

  GuncellemeBilgisi({
    required this.version,
    required this.buildNumber,
    required this.url,
    this.forceUpdate = false,
  });
}

class GuncellemeServisi {
  static const String _updateJsonUrl = 'https://raw.githubusercontent.com/mskaymaz/M_RekatSay/main/update.json';

  Future<GuncellemeBilgisi?> guncellemeKontrolEt() async {
    try {
      final response = await http.get(Uri.parse(_updateJsonUrl));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final packageInfo = await PackageInfo.fromPlatform();
      
      final String remoteVersion = data['version'];
      final int remoteBuild = data['build_number'];
      final int localBuild = int.parse(packageInfo.buildNumber);

      if (remoteBuild > localBuild) {
        return GuncellemeBilgisi(
          version: remoteVersion,
          buildNumber: remoteBuild,
          url: data['url'] ?? UygulamaYapilandirmasi.guncellemeApkBaglantisi,
          forceUpdate: data['force_update'] ?? false,
        );
      }
    } catch (e) {
      // Sessiz hata yönetimi
    }
    return null;
  }
}
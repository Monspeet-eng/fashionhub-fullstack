import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Ubah nilai ini ke IP lokal komputer Anda (contoh: 'http://192.168.1.10:8080/api/v1')
  /// apabila menjalankan aplikasi pada perangkat fisik (HP asli).
  static const String customBaseUrl = 'http://192.168.100.13:8080/api/v1';

  static String get baseUrl {
    if (customBaseUrl.isNotEmpty) {
      return customBaseUrl;
    }
    if (kIsWeb) {
      return 'http://localhost:8080/api/v1';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8080/api/v1';
      default:
        return 'http://localhost:8080/api/v1';
    }
  }
}

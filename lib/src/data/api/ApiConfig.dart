class ApiConfig {
  static const bool isProduction = true;
  // static const String localUrl = '10.0.2.2:8000'; // 127.0.0.1:8000
  static const String remoteUrl = 'siac.villahermosa.gob.mx';
  // static String get baseUrl => isProduction ? remoteUrl : localUrl;
  static bool get useHttps => isProduction;
  static Uri buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    if (useHttps) {
      return Uri.https(remoteUrl, path, queryParameters);
    } else {
      return Uri.http(remoteUrl, path, queryParameters);
    }
  }
}

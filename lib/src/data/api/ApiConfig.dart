/// Configuración de la API SisMMun.
///
/// Centraliza la URL base y la forma de construir URIs para todas las
/// peticiones HTTP. Soporta ambientes de desarrollo y producción.
///
/// Uso:
/// ```dart
/// final url = ApiConfig.buildUri(Endpoints.login);
/// ```
class ApiConfig {
  /// Bandera para seleccionar entre producción y desarrollo local.
  /// Cambia a [false] para usar servidor local en desarrollo.
  static const bool isProduction = true;

  // ---------------------------------------------------------------------------
  // CONFIGURACIÓN LOCAL (solo se usa cuando isProduction = false)
  // ---------------------------------------------------------------------------

  /// IP del emulador Android (apunta al localhost de la PC host)
  static const String emulatorUrl = '10.0.2.2:8000';

  /// IP de la PC en la red local (para dispositivo físico).
  /// Ejecuta: hostname -I | awk '{print $1}' para obtener la IP actual.
  static const String physicalDeviceUrl = '192.168.1.73:8000';

  /// Indica si se prueba en dispositivo físico (true) o emulador (false).
  static const bool isPhysicalDevice = true;

  // ---------------------------------------------------------------------------
  // CONFIGURACIÓN REMOTA (producción)
  // ---------------------------------------------------------------------------

  /// Dominio del servidor de producción
  static const String remoteUrl = 'siac.villahermosa.gob.mx';

  // ---------------------------------------------------------------------------
  // URL ACTIVA
  // ---------------------------------------------------------------------------

  /// URL local según el tipo de dispositivo
  static String get localUrl => isPhysicalDevice ? physicalDeviceUrl : emulatorUrl;

  /// URL base activa según el ambiente
  static String get baseUrl => isProduction ? remoteUrl : localUrl;

  /// Indica si se debe usar HTTPS
  static bool get useHttps => isProduction;

  // ---------------------------------------------------------------------------
  // BUILDER DE URI
  // ---------------------------------------------------------------------------

  /// Construye un [Uri] completo a partir de un [path] relativo.
  ///
  /// [path] - Path del endpoint, ej: '/api/v1/login'
  /// [queryParameters] - Parámetros opcionales de query string
  static Uri buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    if (useHttps) {
      return Uri.https(baseUrl, path, queryParameters);
    } else {
      return Uri.http(baseUrl, path, queryParameters);
    }
  }
}

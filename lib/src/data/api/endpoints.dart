/// Clase que centraliza todos los endpoints de la API SisMMun.
///
/// Todos los paths son relativos a [ApiConfig.buildUri].
///
/// Uso:
/// ```dart
/// final url = ApiConfig.buildUri(Endpoints.login);
/// ```
abstract class Endpoints {
  // ============================================================================
  // AUTH
  // ============================================================================

  /// POST - Iniciar sesión
  static const String login = '/api/v1/login';

  // ============================================================================
  // SOLICITUDES (DENUNCIAS)
  // ============================================================================

  /// POST - Obtener solicitudes del usuario autenticado
  static const String solicitudes = '/api/v1/denuncias/with/roles';

  // ============================================================================
  // IMÁGENES
  // ============================================================================

  /// POST - Agregar imagen a una solicitud atendida
  static const String agregarImagen = '/api/v1/denuncia/agregar/imagen';
}

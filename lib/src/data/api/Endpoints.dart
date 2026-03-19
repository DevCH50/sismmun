/// Clase que centraliza todos los endpoints de la API SisMMun.
///
/// Todos los paths son relativos a [ApiConfig.buildUri].
///
/// Uso:
/// ```dart
/// final url = ApiConfig.buildUri(Endpoints.login);
/// ```
abstract class Endpoints {
  /// Prefijo base de la API v1.
  static const String _base = '/api/v1';

  // ============================================================================
  // AUTH
  // ============================================================================

  /// POST - Iniciar sesión
  static const String login = '$_base/login';

  // ============================================================================
  // SOLICITUDES (DENUNCIAS)
  // ============================================================================

  /// POST - Obtener solicitudes del usuario autenticado
  static const String solicitudes = '$_base/denuncias/with/roles';

  // ============================================================================
  // IMÁGENES
  // ============================================================================

  /// POST - Agregar imagen a una solicitud
  static const String agregarImagen = '$_base/denuncia/agregar/imagen';

  /// POST - Eliminar imagen de una solicitud
  static const String eliminarImagen = '$_base/denuncia/remove/imagen';
  
}

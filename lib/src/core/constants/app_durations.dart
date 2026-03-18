/// Duraciones de la aplicación SisMMun.
///
/// Centraliza todos los tiempos de espera, animaciones y delays
/// para mantener consistencia en la app.
class AppDurations {
  AppDurations._();

  // ============================================================================
  // TIMEOUTS DE RED
  // ============================================================================

  /// Timeout para peticiones HTTP normales (30 segundos)
  static const Duration httpTimeout = Duration(seconds: 30);

  /// Timeout extendido para subida de imágenes (60 segundos)
  static const Duration httpImageUploadTimeout = Duration(seconds: 60);

  /// Timeout para conexión inicial (10 segundos)
  static const Duration connectionTimeout = Duration(seconds: 10);

  // ============================================================================
  // SPLASH SCREEN
  // ============================================================================

  /// Tiempo mínimo de splash
  static const Duration splashMinDuration = Duration(milliseconds: 2000);

  /// Delay antes de verificar sesión
  static const Duration splashSessionCheckDelay = Duration(milliseconds: 500);

  /// Delay del listener de navegación
  static const Duration splashNavigationDelay = Duration(milliseconds: 200);

  // ============================================================================
  // ANIMACIONES
  // ============================================================================

  /// Duración de animaciones cortas
  static const Duration animationFast = Duration(milliseconds: 200);

  /// Duración de animaciones normales
  static const Duration animationNormal = Duration(milliseconds: 300);

  /// Duración de animaciones lentas
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============================================================================
  // UI FEEDBACK
  // ============================================================================

  /// Delay para feedback visual en refresh
  static const Duration refreshFeedback = Duration(milliseconds: 500);
}

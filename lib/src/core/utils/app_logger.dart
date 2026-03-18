import 'package:flutter/foundation.dart';

/// Logger centralizado de la aplicación SisMMun.
///
/// Proporciona un sistema de logging que solo muestra mensajes en modo debug,
/// evitando logs en producción. Categoriza los logs por nivel y contexto.
class AppLogger {
  AppLogger._();

  static const String _tag = 'SisMMun';

  // ============================================================================
  // NIVELES DE LOG
  // ============================================================================

  /// Log de debug - información detallada para desarrollo
  static void debug(String message, {String? tag}) {
    _log('DEBUG', tag ?? _tag, message);
  }

  /// Log de información - eventos importantes
  static void info(String message, {String? tag}) {
    _log('INFO', tag ?? _tag, message);
  }

  /// Log de advertencia - situaciones potencialmente problemáticas
  static void warning(String message, {String? tag}) {
    _log('WARNING', tag ?? _tag, message);
  }

  /// Log de error - errores que no detienen la app
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log('ERROR', tag ?? _tag, message);
    if (error != null) {
      _log('ERROR', tag ?? _tag, 'Exception: $error');
    }
    if (stackTrace != null) {
      _log('ERROR', tag ?? _tag, 'StackTrace: $stackTrace');
    }
  }

  // ============================================================================
  // HELPERS ESPECÍFICOS
  // ============================================================================

  /// Log para inicio de petición HTTP
  static void httpRequest(String method, String url) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String().substring(11, 23);
      debugPrint('[$timestamp] [NETWORK] [$_tag] → $method $url');
    }
  }

  /// Log para respuesta HTTP
  static void httpResponse(int statusCode, String url) {
    if (kDebugMode) {
      final emoji = statusCode >= 200 && statusCode < 300 ? '✓' : '✗';
      final timestamp = DateTime.now().toIso8601String().substring(11, 23);
      debugPrint('[$timestamp] [NETWORK] [$_tag] $emoji [$statusCode] $url');
    }
  }

  /// Log para error HTTP
  static void httpError(String url, Object error) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String().substring(11, 23);
      debugPrint('[$timestamp] [NETWORK] [$_tag] ✗ ERROR $url: $error');
    }
  }

  /// Log para cambio de estado en BLoC
  static void blocEvent(String blocName, String event) {
    _log('BLOC', blocName, 'Evento: $event');
  }

  /// Log para subida de imagen
  static void imageUpload(String message) {
    _log('IMG', _tag, message);
  }

  // ============================================================================
  // IMPLEMENTACIÓN INTERNA
  // ============================================================================

  /// Método interno para imprimir logs. Solo imprime en modo debug.
  static void _log(String level, String tag, String message) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String().substring(11, 23);
      debugPrint('[$timestamp] [$level] [$tag] $message');
    }
  }
}

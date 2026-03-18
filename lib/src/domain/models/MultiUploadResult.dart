/// Resultado de una operación de subida múltiple de imágenes.
///
/// Contiene los contadores de imágenes subidas con éxito y con error,
/// para que la UI pueda mostrar un resumen claro al usuario.
class MultiUploadResult {
  /// Número de imágenes subidas con éxito.
  final int exitosas;

  /// Número de imágenes que fallaron.
  final int errores;

  /// Mensajes de error de las imágenes que fallaron (uno por imagen).
  final List<String> mensajesError;

  /// Total de imágenes que se intentaron subir.
  final int total;

  const MultiUploadResult({
    required this.exitosas,
    required this.errores,
    required this.mensajesError,
    required this.total,
  });

  /// Retorna true si todas las imágenes se subieron correctamente.
  bool get todasExitosas => errores == 0;

  /// Retorna true si al menos una imagen se subió correctamente.
  bool get algunaExitosa => exitosas > 0;

  /// Genera un mensaje resumen para mostrar al usuario.
  String get mensajeResumen {
    if (todasExitosas) {
      return '$exitosas ${exitosas == 1 ? 'imagen subida' : 'imágenes subidas'} correctamente';
    } else if (algunaExitosa) {
      return '$exitosas de $total imágenes subidas. $errores con error.';
    } else {
      return 'No se pudo subir ninguna imagen. Intenta de nuevo.';
    }
  }
}

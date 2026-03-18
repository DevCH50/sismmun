import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:sismmun/src/core/utils/app_logger.dart';

/// Utilidad para comprimir imágenes
class ImageCompressor {
  /// Comprime una imagen reduciendo su calidad y tamaño
  /// 
  /// [archivo] Archivo original de la imagen
  /// [quality] Calidad de compresión (0-100), por defecto 70
  /// [minWidth] Ancho mínimo de la imagen, por defecto 800
  /// [minHeight] Alto mínimo de la imagen, por defecto 800
  /// 
  /// Returns el archivo comprimido o el original si falla la compresión
  Future<File> comprimirImagen(
    File archivo, {
    int quality = 70,
    int minWidth = 800,
    int minHeight = 800,
  }) async {
    try {
      // Genera ruta destino compatible con cualquier extensión de imagen
      final rutaDestino = archivo.path.replaceAll(
        RegExp(r'\.(jpg|jpeg|png|webp)$', caseSensitive: false),
        '_compressed.jpg',
      );

      final resultado = await FlutterImageCompress.compressAndGetFile(
        archivo.absolute.path,
        rutaDestino,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      return resultado != null ? File(resultado.path) : archivo;
    } catch (e) {
      AppLogger.error('Error al comprimir imagen: $e', tag: 'ImageCompressor');
      // Si falla la compresión, devolver la imagen original
      return archivo;
    }
  }
}

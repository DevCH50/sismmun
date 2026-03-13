import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
      final rutaDestino = archivo.path.replaceAll('.jpg', '_compressed.jpg');

      final resultado = await FlutterImageCompress.compressAndGetFile(
        archivo.absolute.path,
        rutaDestino,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      return resultado != null ? File(resultado.path) : archivo;
    } catch (e) {
      print('❌ Error al comprimir imagen: $e');
      // Si falla la compresión, devolver la imagen original
      return archivo;
    }
  }
}

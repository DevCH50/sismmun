import 'package:sismmun/src/domain/models/Imagen.dart';

/// Resultado de subir una imagen
class ImageUploadResult {
  final bool success;
  final String message;
  final Imagen? imagen;

  ImageUploadResult({
    required this.success,
    required this.message,
    this.imagen,
  });

  factory ImageUploadResult.success(Imagen imagen) {
    return ImageUploadResult(
      success: true,
      message: imagen.msg,
      imagen: imagen,
    );
  }

  factory ImageUploadResult.error(String message) {
    return ImageUploadResult(
      success: false,
      message: message,
      imagen: null,
    );
  }
}

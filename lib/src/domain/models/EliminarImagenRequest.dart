/// Modelo de petición para eliminar una imagen de una solicitud.
///
/// El backend espera vía POST:
/// ```json
/// {
///   "denuncia_id": 456,
///   "imagen_id": 789
/// }
/// ```
class EliminarImagenRequest {
  /// ID de la solicitud (denuncia) a la que pertenece la imagen.
  final int denunciaId;

  /// ID de la imagen a eliminar.
  final int imagenId;

  final int userId;

  const EliminarImagenRequest({
    required this.denunciaId,
    required this.imagenId,
    required this.userId,
  });

  Map<String, dynamic> toMap() => {
        'denuncia_id': denunciaId,
        'imagen_id': imagenId,
        'user_id': userId,
      };
}

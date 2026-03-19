import 'dart:io';

import 'package:sismmun/src/domain/models/EliminarImagenRequest.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

/// Interface del repositorio de solicitudes
abstract class SolicitudRepository {
  /// Sube una imagen de una solicitud atendida
  Future<Resource<Imagen>> subirImagen(SubirImagenRequest request);

  /// Elimina una imagen de una solicitud
  Future<Resource<bool>> eliminarImagen(EliminarImagenRequest request);

  Future<Resource<File>> getImagen(String imagenPath);
}

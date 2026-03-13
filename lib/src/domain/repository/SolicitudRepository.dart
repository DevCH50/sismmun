import 'dart:io';

import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

/// Interface del repositorio de solicitudes
abstract class SolicitudRepository {
  /// Sube una imagen de una solicitud atendida
  Future<Resource<Imagen>> subirImagen(SubirImagenRequest request);

  Future<Resource<File>> getImagen(String imagenPath);

}

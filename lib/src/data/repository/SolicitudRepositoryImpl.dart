import 'dart:io';
import 'package:sismmun/src/data/dataSource/local/ImageCompressor.dart';
import 'package:sismmun/src/data/dataSource/local/SharedPref.dart';
import 'package:sismmun/src/data/dataSource/remote/services/SolicitudService.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/domain/repository/SolicitudRepository.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

/// Implementación del repositorio de solicitudes
class SolicitudRepositoryImpl implements SolicitudRepository {
  final SolicitudService solicitudService;
  final ImageCompressor imageCompressor;
  final SharedPref sharedPref;

  SolicitudRepositoryImpl(
    this.solicitudService,
    this.imageCompressor,
    this.sharedPref,
  );

  @override
  Future<Resource<Imagen>> subirImagen(SubirImagenRequest request) async {
    try {
      final archivoOriginal = File(request.imagenPath);
      final archivoComprimido = await imageCompressor.comprimirImagen(
        archivoOriginal,
        quality: 70,
        minWidth: 800,
        minHeight: 800,
      );

      final requestComprimida = SubirImagenRequest(
        dependenciaId: request.dependenciaId,
        solicitudId: request.solicitudId,
        estatusId: request.estatusId,
        servicioId: request.servicioId,
        imagenPath: archivoComprimido.path,
        latitud: request.latitud,
        longitud: request.longitud,
      );

      final imagen = await solicitudService.subirImagen(requestComprimida);
      return Success(imagen);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Resource<File>> getImagen(String imagenPath) async {
    try {
      final imagenArchivo = File(imagenPath);
      return Success(imagenArchivo);
    } catch (e) {
      return Error(e.toString());
    }
  }


}

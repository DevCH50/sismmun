
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/domain/repository/SolicitudRepository.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

/// Caso de uso para subir imagen de solicitud atendida
class SubirImagenUseCase {
  final SolicitudRepository solicitudRepository;

  SubirImagenUseCase(this.solicitudRepository);

  /// Ejecuta el caso de uso de subir imagen
  Future<Resource<Imagen>> run(SubirImagenRequest request) async {
    return await solicitudRepository.subirImagen(request);
  }

}

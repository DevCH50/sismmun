import 'package:sismmun/src/domain/models/EliminarImagenRequest.dart';
import 'package:sismmun/src/domain/repository/SolicitudRepository.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

/// Caso de uso para eliminar una imagen de una solicitud.
class EliminarImagenUseCase {
  final SolicitudRepository solicitudRepository;

  EliminarImagenUseCase(this.solicitudRepository);

  Future<Resource<bool>> run(EliminarImagenRequest request) async {
    return await solicitudRepository.eliminarImagen(request);
  }
}

import 'package:sismmun/src/domain/useCases/solicitudes/EliminarImagenUseCase.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/SubirImagenUseCase.dart';

/// Contenedor de casos de uso de solicitudes
class SolicitudUseCases {
  final SubirImagenUseCase subirImagen;
  final EliminarImagenUseCase eliminarImagen;

  SolicitudUseCases({
    required this.subirImagen,
    required this.eliminarImagen,
  });
}

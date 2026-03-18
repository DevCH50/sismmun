import 'package:image_picker/image_picker.dart';
import 'package:sismmun/injection.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/ImageUploadResult.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/SolicitudUseCases.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';
import 'package:sismmun/src/presentation/utils/LocationHelper.dart';

class ImageUploaderHelper {
  final ImagePicker _picker = ImagePicker();

  /// Selecciona una imagen y la sube al servidor
  /// Devuelve el resultado con la imagen si fue exitosa
  ///
  /// [onImageUploaded] callback opcional que se llama cuando la imagen se sube exitosamente
  /// [observacion] texto descriptivo de la imagen (opcional)
  /// [tipoFoto] indica si es foto de Antes o Después (opcional)
  Future<ImageUploadResult?> seleccionarYSubirImagen({
    required ImageSource origen,
    required int solicitudId,
    required int dependenciaId,
    required int estatusId,
    required int servicioId,
    required Function(bool) onUploadingChanged,
    Function(Imagen)? onImageUploaded,
    bool soloImagen = false,
    String? observaciones,
    TipoFoto? tipoFoto,
  }) async {
    try {
      final XFile? imagenSeleccionada = await _picker.pickImage(
        source: origen,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (imagenSeleccionada == null) return null;

      onUploadingChanged(true);

      // Obtener ubicación
      final ubicacion = await LocationHelper.obtenerUbicacion();

      // Crear request con ubicación y metadatos
      final request = SubirImagenRequest(
        solicitudId: solicitudId,
        dependenciaId: dependenciaId,
        estatusId: estatusId,
        servicioId: servicioId,
        imagenPath: imagenSeleccionada.path,
        latitud: ubicacion?.latitude,
        longitud: ubicacion?.longitude,
        soloImagen: soloImagen,
        observaciones: observaciones,
        tipoFoto: tipoFoto,
      );

      // Obtener el useCase de GetIt
      final solicitudUseCases = locator<SolicitudUseCases>();

      // Ejecutar la subida
      final Resource<Imagen> result = await solicitudUseCases.subirImagen.run(request);

      onUploadingChanged(false);

      if (result is Success<Imagen>) {
        final imagen = result.data;

        // Notificar si la imagen se subió exitosamente
        if (imagen.status == 1 && onImageUploaded != null) {
          onImageUploaded(imagen);
        }

        return ImageUploadResult.success(imagen);
      } else if (result is Error<Imagen>) {
        return ImageUploadResult.error(result.msg);
      }

      return ImageUploadResult.error('Error desconocido');
    } catch (e) {
      onUploadingChanged(false);
      return ImageUploadResult.error(e.toString());
    }
  }

  /// Sube una imagen ya seleccionada con sus metadatos
  ///
  /// Este método no selecciona la imagen, solo la sube.
  /// Útil cuando se necesita mostrar un modal intermedio para capturar metadatos.
  ///
  /// [imagenPath] ruta de la imagen ya seleccionada
  /// [observacion] texto descriptivo de la imagen
  /// [tipoFoto] indica si es foto de Antes o Después
  Future<ImageUploadResult?> subirImagenConMetadatos({
    required String imagenPath,
    required int solicitudId,
    required int dependenciaId,
    required int estatusId,
    required int servicioId,
    required String observaciones,
    required TipoFoto tipoFoto,
    Function(Imagen)? onImageUploaded,
    bool soloImagen = false,
  }) async {
    try {
      // Obtener ubicación
      final ubicacion = await LocationHelper.obtenerUbicacion();

      // Crear request con ubicación y metadatos
      final request = SubirImagenRequest(
        solicitudId: solicitudId,
        dependenciaId: dependenciaId,
        estatusId: estatusId,
        servicioId: servicioId,
        imagenPath: imagenPath,
        latitud: ubicacion?.latitude,
        longitud: ubicacion?.longitude,
        soloImagen: soloImagen,
        observaciones: observaciones,
        tipoFoto: tipoFoto,
      );

      // Obtener el useCase de GetIt
      final solicitudUseCases = locator<SolicitudUseCases>();

      // Ejecutar la subida
      final Resource<Imagen> result = await solicitudUseCases.subirImagen.run(request);

      if (result is Success<Imagen>) {
        final imagen = result.data;

        // Notificar si la imagen se subió exitosamente
        if (imagen.status == 1 && onImageUploaded != null) {
          onImageUploaded(imagen);
        }

        return ImageUploadResult.success(imagen);
      } else if (result is Error<Imagen>) {
        return ImageUploadResult.error(result.msg);
      }

      return ImageUploadResult.error('Error desconocido');
    } catch (e) {
      return ImageUploadResult.error(e.toString());
    }
  }
}

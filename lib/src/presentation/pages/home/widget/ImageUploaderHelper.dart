import 'package:image_picker/image_picker.dart';
import 'package:sismmun/src/core/constants/app_strings.dart';
import 'package:sismmun/injection.dart';
import 'package:sismmun/src/domain/models/EliminarImagenRequest.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/ImageUploadResult.dart';
import 'package:sismmun/src/domain/models/MultiUploadResult.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/SolicitudUseCases.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';
import 'package:sismmun/src/presentation/utils/LocationHelper.dart';

class ImageUploaderHelper {
  final ImagePicker _picker = ImagePicker();

  /// Obtiene el userId de la sesión activa. Retorna 0 si no hay sesión.
  Future<int> _getUserId() async {
    final authUseCases = locator<AuthUseCases>();
    final session = await authUseCases.getUserSession.run();
    return session?.user.id ?? 0;
  }

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

      // Obtener ubicación y userId en paralelo
      final results = await Future.wait([
        LocationHelper.obtenerUbicacion(),
        _getUserId(),
      ]);
      final ubicacion = results[0] as dynamic;
      final userId = results[1] as int;

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
        userId: userId,
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

      return ImageUploadResult.error(AppStrings.errorDesconocido);
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
      // Obtener ubicación y userId en paralelo
      final results = await Future.wait([
        LocationHelper.obtenerUbicacion(),
        _getUserId(),
      ]);
      final ubicacion = results[0] as dynamic;
      final userId = results[1] as int;

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
        userId: userId,
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

      return ImageUploadResult.error(AppStrings.errorDesconocido);
    } catch (e) {
      return ImageUploadResult.error(e.toString());
    }
  }

  /// Sube múltiples imágenes secuencialmente al servidor.
  ///
  /// Itera sobre [imagePaths] llamando a [subirImagenConMetadatos] por cada una.
  /// Llama a [onProgreso] con (actual, total) antes de cada subida para
  /// que el caller pueda mostrar progreso ("Subiendo 2 de 5...").
  /// Si una imagen falla, continúa con las siguientes.
  ///
  /// Retorna un [MultiUploadResult] con los contadores de éxito y error.
  Future<MultiUploadResult> subirMultiplesImagenes({
    required List<String> imagePaths,
    required int solicitudId,
    required int dependenciaId,
    required int estatusId,
    required int servicioId,
    required String observaciones,
    required TipoFoto tipoFoto,
    bool soloImagen = false,
    Function(Imagen)? onImageUploaded,
    Function(int actual, int total)? onProgreso,
  }) async {
    int exitosas = 0;
    int errores = 0;
    final List<String> mensajesError = [];

    for (int i = 0; i < imagePaths.length; i++) {
      // Notificar progreso antes de cada subida
      onProgreso?.call(i + 1, imagePaths.length);

      final result = await subirImagenConMetadatos(
        imagenPath: imagePaths[i],
        solicitudId: solicitudId,
        dependenciaId: dependenciaId,
        estatusId: estatusId,
        servicioId: servicioId,
        observaciones: observaciones,
        tipoFoto: tipoFoto,
        soloImagen: soloImagen,
        onImageUploaded: onImageUploaded,
      );

      if (result != null && result.success) {
        exitosas++;
      } else {
        errores++;
        mensajesError.add(result?.message ?? AppStrings.errorDesconocido);
      }
    }

    return MultiUploadResult(
      exitosas: exitosas,
      errores: errores,
      mensajesError: mensajesError,
      total: imagePaths.length,
    );
  }

  /// Elimina una imagen del servidor.
  ///
  /// [denunciaId] - ID de la solicitud a la que pertenece la imagen.
  /// [imagenId] - ID de la imagen a eliminar.
  /// Retorna `Success(true)` si se eliminó, `Error(msg)` con el mensaje del backend.
  Future<Resource<bool>> eliminarImagen({
    required int denunciaId,
    required int imagenId,
  }) async {
    try {
      final userId = await _getUserId();
      final solicitudUseCases = locator<SolicitudUseCases>();
      final request = EliminarImagenRequest(
        denunciaId: denunciaId,
        imagenId: imagenId,
        userId: userId,
      );
      return await solicitudUseCases.eliminarImagen.run(request);
    } catch (e) {
      return Error(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}

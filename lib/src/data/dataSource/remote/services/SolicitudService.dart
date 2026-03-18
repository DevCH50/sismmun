import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sismmun/src/core/constants/app_durations.dart';
import 'package:sismmun/src/core/constants/app_strings.dart';
import 'package:sismmun/src/core/utils/app_logger.dart';
import 'package:sismmun/src/data/api/ApiConfig.dart';
import 'package:sismmun/src/data/api/endpoints.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';

/// Servicio HTTP para gestionar peticiones relacionadas con solicitudes.
///
/// Maneja la subida de imágenes al servidor ServiMun, incluyendo
/// metadatos como latitud, longitud, observación y tipo de foto.
class SolicitudService {
  final AuthUseCases authUseCases;

  SolicitudService(this.authUseCases);

  /// Sube una imagen de una solicitud atendida al servidor.
  ///
  /// [request] - Datos de la petición incluyendo imagenPath y metadatos.
  /// Retorna un objeto [Imagen] con la información de la imagen subida.
  /// Lanza [Exception] si la petición falla.
  Future<Imagen> subirImagen(SubirImagenRequest request) async {
    try {
      final AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse == null) {
        throw Exception(AppStrings.errorNoSession);
      }

      final int userId = authResponse.user.id;
      final String token = authResponse.accessToken;

      final uri = ApiConfig.buildUri(Endpoints.agregarImagen);
      final imagenArchivo = File(request.imagenPath);
      final bytes = await imagenArchivo.readAsBytes();
      final imagenBase64 = base64Encode(bytes);

      final body = <String, dynamic>{
        'user_id': userId,
        'solo_imagen': request.soloImagen ? 1 : 0,
        'denuncia_id': request.solicitudId,
        'dependencia_id': request.dependenciaId,
        'estatus_id': request.estatusId,
        'servicio_id': request.servicioId,
        'imagen': imagenBase64,
        'latitud': request.latitud ?? 0,
        'longitud': request.longitud ?? 0,
        'observacion': request.observaciones ?? '',
        'tipo_foto': request.tipoFoto?.valor ?? '',
      };

      AppLogger.httpRequest('POST', uri.toString());
      AppLogger.imageUpload(
        'Subiendo imagen denuncia_id: ${request.solicitudId}',
      );

      final response = await http
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: json.encode(body),
          )
          .timeout(AppDurations.httpImageUploadTimeout);

      AppLogger.httpResponse(response.statusCode, uri.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        final int status = data['status'] ?? 0;
        final String msg = data['msg'] ?? '';

        AppLogger.info(
          'Imagen subida. status: $status, msg: $msg',
          tag: 'Solicitud',
        );

        return Imagen(
          fecha: DateTime.now().toString(),
          urlImagen: data['url_imagen'] ?? '',
          urlThumb: data['url_thumb'] ?? '',
          status: status,
          msg: msg,
        );
      } else {
        throw Exception(
          'Error del servidor: ${response.statusCode} - ${response.body}',
        );
      }
    } on TimeoutException {
      AppLogger.error('Timeout al subir imagen', tag: 'Solicitud');
      throw Exception(AppStrings.errorTimeout);
    } catch (e) {
      AppLogger.error('Error en subirImagen: $e', tag: 'Solicitud');
      rethrow;
    }
  }
}

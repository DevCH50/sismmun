import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sismmun/src/data/api/ApiConfig.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';

/// Servicio para gestionar peticiones HTTP relacionadas con solicitudes
class SolicitudService {
  final AuthUseCases authUseCases;

  SolicitudService(this.authUseCases);

  /// Sube una imagen de una solicitud atendida al servidor
  ///
  /// [request] Datos de la petición (userId, solicitudId, estatusId, imagenPath)
  ///
  /// Returns un objeto Imagen con la información de la imagen subida
  /// Throws Exception si la petición falla
  Future<Imagen> subirImagen(SubirImagenRequest request) async {
    try {
      final uri = ApiConfig.buildUri('/api/v1/denuncia/agregar/imagen');
      final imagenArchivo = File(request.imagenPath);

      final AuthResponse? authResponse = await authUseCases.getUserSession.run();
      int userId = 0;
      String token = '';
      if (authResponse != null) {
        userId = authResponse.user.id;
        token = authResponse.accessToken;
      } else {
        throw Exception('No hay sesión activa');
      }

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
        'observacion': request.observacion ?? '',
        'tipo_foto': request.tipoFoto?.valor ?? '',
      };

      if (kDebugMode) {
        print('📦 PAYLOAD subir imagen - denuncia_id: ${request.solicitudId}');
      }

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
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        // Extraer status y msg de la respuesta
        final int status = data['status'] ?? 0;
        final String msg = data['msg'] ?? '';

        // Crear imagen con status y msg
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
      throw Exception('Tiempo de espera agotado al subir la imagen.');
    } catch (e) {
      rethrow;
    }
  }
}

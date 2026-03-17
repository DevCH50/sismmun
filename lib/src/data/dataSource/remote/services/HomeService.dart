import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sismmun/src/data/api/ApiConfig.dart';
import 'package:sismmun/src/domain/models/SolicitudesResponse.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:sismmun/src/domain/utils/ListToString.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;

import 'package:sismmun/src/data/dataSource/local/SharedPref.dart';

class HomeService {
  final SharedPref sharedPref;
  final AuthUseCases authUseCases;

  // ✅ Inyectar SharedPref
  HomeService(this.sharedPref, this.authUseCases);

  Future<Resource<SolicitudesResponse>> getSolicitudes() async {
    try {
      // ✅ Obtener userId y token de la sesión

      final AuthResponse? authResponse = await authUseCases.getUserSession.run();
      int userId = 0;
      String token = '';
      if (authResponse != null) {
        if (kDebugMode) print('USUARIO id: ${authResponse.user.id}');
        userId = authResponse.user.id;
        token = authResponse.accessToken;
      } else {
        return Error<SolicitudesResponse>('⚠️ No hay sesión activa');
      }

      // Validar que existan
      if (userId == 0) {
        return Error<SolicitudesResponse>(
          'No se encontró el ID de usuario en la sesión',
        );
      }

      if (token.isEmpty) {
        return Error<SolicitudesResponse>(
          'No se encontró el token de autenticación',
        );
      }

      // ✅ Usar el userId dinámicamente en la URL
      // Uri url = Uri.https(ApiConfig.baseUrl, "/api/v1/Homes/$userId");

      final Uri url = ApiConfig.buildUri('/api/v1/denuncias/with/roles');

      if (kDebugMode) print('🎬 HomesService: url $url');

      // ✅ Agregar el Bearer token
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final String bodyParams = json.encode({
        'user_id': userId,
      });

      final response = await http
          .post(url, headers: headers, body: bodyParams)
          .timeout(const Duration(seconds: 30));
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final SolicitudesResponse solicitudesResponse = SolicitudesResponse.fromJson(data);
        return Success(solicitudesResponse);
      } else {
        return Error<SolicitudesResponse>(ListToString(data['msg']));
      }
    } on TimeoutException {
      return Error<SolicitudesResponse>('Tiempo de espera agotado. Verifica tu conexión.');
    } catch (e) {
      if (kDebugMode) print('Error en el Server => $e');
      return Error<SolicitudesResponse>('Error de conexión. Intenta de nuevo.');
    }
  }
}

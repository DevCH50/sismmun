import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sismmun/src/core/constants/app_durations.dart';
import 'package:sismmun/src/core/constants/app_strings.dart';
import 'package:sismmun/src/core/utils/app_logger.dart';
import 'package:sismmun/src/data/api/ApiConfig.dart';
import 'package:sismmun/src/data/api/endpoints.dart';
import 'package:sismmun/src/data/dataSource/local/SharedPref.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/models/SolicitudesResponse.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:sismmun/src/domain/utils/ListToString.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

/// Servicio HTTP para obtener las solicitudes del usuario.
///
/// Se comunica con el backend ServiMun para traer las denuncias/solicitudes
/// asociadas al usuario autenticado. Requiere token Bearer válido.
class HomeService {
  final SharedPref sharedPref;
  final AuthUseCases authUseCases;

  HomeService(this.sharedPref, this.authUseCases);

  /// Obtiene las solicitudes del usuario autenticado.
  ///
  /// Usa el token de sesión para autenticar la petición.
  /// Retorna [Success] con [SolicitudesResponse] o [Error] con mensaje.
  Future<Resource<SolicitudesResponse>> getSolicitudes() async {
    try {
      final AuthResponse? authResponse = await authUseCases.getUserSession.run();

      if (authResponse == null) {
        return Error<SolicitudesResponse>(AppStrings.errorNoSession);
      }

      final int userId = authResponse.user.id;
      final String token = authResponse.accessToken;

      if (userId == 0) {
        return Error<SolicitudesResponse>(AppStrings.errorNoUserId);
      }

      if (token.isEmpty) {
        return Error<SolicitudesResponse>(AppStrings.errorNoToken);
      }

      final Uri url = ApiConfig.buildUri(Endpoints.solicitudes);

      AppLogger.httpRequest('POST', url.toString());
      AppLogger.debug('userId: $userId', tag: 'Home');

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final String bodyParams = json.encode({'user_id': userId});

      final response = await http
          .post(url, headers: headers, body: bodyParams)
          .timeout(AppDurations.httpTimeout);

      final data = json.decode(response.body);

      AppLogger.httpResponse(response.statusCode, url.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final SolicitudesResponse solicitudesResponse = SolicitudesResponse.fromJson(data);
        AppLogger.info(
          'Solicitudes cargadas: ${solicitudesResponse.solicitudes.length}',
          tag: 'Home',
        );
        return Success(solicitudesResponse);
      } else {
        final errorMsg = ListToString(data['msg']);
        AppLogger.warning('Error al obtener solicitudes: $errorMsg', tag: 'Home');
        return Error<SolicitudesResponse>(errorMsg);
      }
    } on TimeoutException {
      AppLogger.error('Timeout al obtener solicitudes', tag: 'Home');
      return Error<SolicitudesResponse>(AppStrings.errorTimeout);
    } catch (e) {
      AppLogger.error('Error en getSolicitudes: $e', tag: 'Home');
      return Error<SolicitudesResponse>(AppStrings.errorConnectionRetry);
    }
  }
}

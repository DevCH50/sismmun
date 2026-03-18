import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sismmun/src/core/constants/app_durations.dart';
import 'package:sismmun/src/core/constants/app_strings.dart';
import 'package:sismmun/src/core/utils/app_logger.dart';
import 'package:sismmun/src/data/api/ApiConfig.dart';
import 'package:sismmun/src/data/api/endpoints.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/utils/ListToString.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

/// Servicio HTTP para operaciones de autenticación.
///
/// Maneja las peticiones al API para login de usuarios.
/// Incluye timeout y manejo de errores de conexión.
class AuthService {
  /// Realiza el login del usuario contra el servidor.
  ///
  /// [username] - Nombre de usuario o email.
  /// [password] - Contraseña del usuario.
  /// Retorna [Success] con [AuthResponse] o [Error] con mensaje.
  Future<Resource<AuthResponse>> login(String username, String password) async {
    final Uri url = ApiConfig.buildUri(Endpoints.login);

    AppLogger.httpRequest('POST', url.toString());

    try {
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      final String bodyParams = json.encode({
        'username': username,
        'password': password,
      });

      final response = await http
          .post(url, headers: headers, body: bodyParams)
          .timeout(AppDurations.httpTimeout);

      final data = json.decode(response.body);

      AppLogger.httpResponse(response.statusCode, url.toString());

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['access_token'] != null) {
        final AuthResponse authResponse = AuthResponse.fromJson(data);
        AppLogger.info('Login exitoso para usuario: $username', tag: 'Auth');
        return Success(authResponse);
      } else {
        final errorMsg = ListToString(
          data['msg'] ?? data['message'] ?? data['error'] ?? AppStrings.errorInvalidCredentials,
        );
        AppLogger.warning('Login fallido: $errorMsg', tag: 'Auth');
        return Error(
          errorMsg.isNotEmpty ? errorMsg : AppStrings.errorInvalidCredentials,
        );
      }
    } on TimeoutException {
      AppLogger.error('Timeout en login', tag: 'Auth');
      return Error(AppStrings.errorTimeout);
    } catch (e) {
      AppLogger.error('Error en login: $e', tag: 'Auth');
      return Error(AppStrings.errorConnectionRetry);
    }
  }
}

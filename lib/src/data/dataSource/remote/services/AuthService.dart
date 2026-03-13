import 'dart:convert';
import 'package:sismmun/src/data/api/ApiConfig.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/utils/ListToString.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Resource<AuthResponse>> login(String username, String password) async {
    // Implement login logic here
    try {
      // Uri url = Uri.https(ApiConfig.baseUrl, "/api/v1/login");
      final Uri url = ApiConfig.buildUri('/api/v1/login');
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      final String bodyParams = json.encode({
        'username': username,
        'password': password,
      });
      final response = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      if ((response.statusCode == 200 || response.statusCode == 201) && data['access_token'] != null) {
        final AuthResponse authResponse = AuthResponse.fromJson(data);
        return Success(authResponse);
      } else {
        return Error(ListToString(data['msg']) .isNotEmpty
            ? ListToString(data['msg'])
            : 'Credenciales incorrectas o acceso denegado');
      }
    } catch (e) {
      print('Error en el Server => $e');
      return Error(e.toString());
    }
  }
}

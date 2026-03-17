// Tests unitarios para el modelo AuthResponse
// Verifica parsing JSON seguro y serialización
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';

void main() {
  // JSON de respuesta completa típica del servidor
  final jsonCompleto = {
    'status': 200,
    'msg': 'Login exitoso',
    'access_token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test',
    'token_type': 'Bearer',
    'api_version': '1.0',
    'app_version': '1.0.0',
    'user': {
      'id': 1,
      'username': 'jdoe',
      'email': 'jdoe@villahermosa.gob.mx',
      'nombre': 'Juan',
      'ap_paterno': 'Doe',
      'ap_materno': 'García',
      'curp': 'DOGJ900101HTCRNN09',
      'celulares': '9931234567',
      'fecha_nacimiento': null,
      'filename_thumb': null,
      'role_id_array': [1, 2],
      'dependencia_id_array': [3],
      'str_genero': 'M',
      'full_name': 'Juan Doe García',
    },
  };

  group('AuthResponse.fromJson', () {
    test('parsea un JSON completo correctamente', () {
      final auth = AuthResponse.fromJson(jsonCompleto);

      expect(auth.status, 200);
      expect(auth.msg, 'Login exitoso');
      expect(auth.accessToken, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test');
      expect(auth.tokenType, 'Bearer');
      expect(auth.apiVersion, '1.0');
      expect(auth.appVersion, '1.0.0');
      expect(auth.user.id, 1);
      expect(auth.user.username, 'jdoe');
    });

    test('usa valores por defecto cuando los campos son null', () {
      final json = <String, dynamic>{
        'status': null,
        'msg': null,
        'access_token': null,
        'token_type': null,
        'api_version': null,
        'app_version': null,
        'user': null,
      };

      final auth = AuthResponse.fromJson(json);

      expect(auth.status, 0);
      expect(auth.msg, '');
      expect(auth.accessToken, '');
      expect(auth.tokenType, '');
      expect(auth.apiVersion, '');
      expect(auth.appVersion, '');
    });

    test('no lanza excepción con JSON vacío', () {
      expect(() => AuthResponse.fromJson({}), returnsNormally);
    });

    test('toJson serializa y puede reimportarse correctamente', () {
      final auth = AuthResponse.fromJson(jsonCompleto);
      final json = auth.toJson();
      final auth2 = AuthResponse.fromJson(json);

      expect(auth2.accessToken, auth.accessToken);
      expect(auth2.user.id, auth.user.id);
    });

    test('accessToken no está vacío en login válido', () {
      final auth = AuthResponse.fromJson(jsonCompleto);
      expect(auth.accessToken, isNotEmpty);
    });
  });
}

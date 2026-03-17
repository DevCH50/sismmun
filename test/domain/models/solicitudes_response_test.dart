// Tests unitarios para el modelo SolicitudesResponse
// Verifica parsing seguro de la lista de solicitudes y valores por defecto
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/models/SolicitudesResponse.dart';
import 'package:sismmun/src/domain/models/Solicitud.dart';

void main() {
  group('SolicitudesResponse.fromJson', () {
    test('parsea un JSON completo con solicitudes', () {
      final json = {
        'status': 200,
        'msg': 'OK',
        'solicitudes': [
          {
            'solicitud_id': 1,
            'fecha_ingreso': '2026-01-01',
            'fecha_ultimo_estatus': '2026-01-10',
            'denuncia': 'Bache',
            'dependencia_id': 1,
            'dependencia': 'Obras',
            'servicio_id': 1,
            'servicio': 'Bacheo',
            'servicio_ultimo_estatus_id': 1,
            'servicio_ultimo_estatus': 'Recibido',
            'ultimo_estatus_id': 1,
            'ultimo_estatus': 'Recibida',
            'origen_id': 1,
            'origen': 'APP',
            'latitud': '17.9',
            'longitud': '-92.9',
            'observaciones': '',
            'imagenes': null,
            'respuestas': null,
          },
        ],
      };

      final response = SolicitudesResponse.fromJson(json);

      expect(response.status, 200);
      expect(response.msg, 'OK');
      expect(response.solicitudes, hasLength(1));
      expect(response.solicitudes.first, isA<Solicitud>());
    });

    test('lista vacía cuando solicitudes es null', () {
      final json = {
        'status': 200,
        'msg': 'Sin solicitudes',
        'solicitudes': null,
      };

      final response = SolicitudesResponse.fromJson(json);

      expect(response.solicitudes, isEmpty);
    });

    test('usa valores por defecto cuando los campos son null', () {
      final json = <String, dynamic>{
        'status': null,
        'msg': null,
        'solicitudes': null,
      };

      final response = SolicitudesResponse.fromJson(json);

      expect(response.status, 0);
      expect(response.msg, '');
      expect(response.solicitudes, isEmpty);
    });

    test('no lanza excepción con JSON vacío', () {
      expect(() => SolicitudesResponse.fromJson({}), returnsNormally);
    });

    test('toJson serializa correctamente', () {
      final json = {
        'status': 200,
        'msg': 'OK',
        'solicitudes': <dynamic>[],
      };

      final response = SolicitudesResponse.fromJson(json);
      final resultado = response.toJson();

      expect(resultado['status'], 200);
      expect(resultado['msg'], 'OK');
      expect(resultado['solicitudes'], isEmpty);
    });
  });
}

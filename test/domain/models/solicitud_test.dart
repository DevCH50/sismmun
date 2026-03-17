// Tests unitarios para el modelo Solicitud
// Verifica parsing JSON seguro, valores por defecto y casos extremos
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/models/Solicitud.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/Respuesta.dart';

void main() {
  group('Solicitud.fromJson', () {
    test('parsea un JSON completo correctamente', () {
      final json = {
        'solicitud_id': 101,
        'fecha_ingreso': '2026-01-10',
        'fecha_ultimo_estatus': '2026-01-15',
        'denuncia': 'Bache en calle principal',
        'dependencia_id': 2,
        'dependencia': 'Obras Públicas',
        'servicio_id': 5,
        'servicio': 'Bacheo',
        'servicio_ultimo_estatus_id': 3,
        'servicio_ultimo_estatus': 'En proceso',
        'ultimo_estatus_id': 17,
        'ultimo_estatus': 'Atendida',
        'origen_id': 1,
        'origen': 'APP',
        'latitud': '17.9870',
        'longitud': '-92.9476',
        'observaciones': 'Urgente',
        'imagenes': [],
        'respuestas': [],
      };

      final solicitud = Solicitud.fromJson(json);

      expect(solicitud.solicitudId, 101);
      expect(solicitud.denuncia, 'Bache en calle principal');
      expect(solicitud.ultimoEstatus, 'Atendida');
      expect(solicitud.origen, 'APP');
      expect(solicitud.imagenes, isEmpty);
      expect(solicitud.respuestas, isEmpty);
    });

    test('usa valores por defecto cuando los campos son null', () {
      final json = <String, dynamic>{
        'solicitud_id': null,
        'fecha_ingreso': null,
        'fecha_ultimo_estatus': null,
        'denuncia': null,
        'dependencia_id': null,
        'dependencia': null,
        'servicio_id': null,
        'servicio': null,
        'servicio_ultimo_estatus_id': null,
        'servicio_ultimo_estatus': null,
        'ultimo_estatus_id': null,
        'ultimo_estatus': null,
        'origen_id': null,
        'origen': null,
        'latitud': null,
        'longitud': null,
        'observaciones': null,
        'imagenes': null,
        'respuestas': null,
      };

      final solicitud = Solicitud.fromJson(json);

      expect(solicitud.solicitudId, 0);
      expect(solicitud.fechaIngreso, '');
      expect(solicitud.denuncia, '');
      expect(solicitud.ultimoEstatus, '');
      expect(solicitud.origen, '');
      expect(solicitud.imagenes, isEmpty);
      expect(solicitud.respuestas, isEmpty);
    });

    test('no lanza excepción cuando faltan campos', () {
      final json = <String, dynamic>{};

      expect(() => Solicitud.fromJson(json), returnsNormally);
    });

    test('parsea listas de imágenes y respuestas correctamente', () {
      final json = {
        'solicitud_id': 1,
        'fecha_ingreso': '2026-01-10',
        'fecha_ultimo_estatus': '2026-01-15',
        'denuncia': 'Test',
        'dependencia_id': 1,
        'dependencia': 'Dep',
        'servicio_id': 1,
        'servicio': 'Serv',
        'servicio_ultimo_estatus_id': 1,
        'servicio_ultimo_estatus': 'Est',
        'ultimo_estatus_id': 1,
        'ultimo_estatus': 'Recibida',
        'origen_id': 1,
        'origen': 'APP',
        'latitud': '0',
        'longitud': '0',
        'observaciones': '',
        'imagenes': [
          {'fecha': '2026-01-10', 'url_imagen': 'http://test.com/img.jpg', 'url_thumb': 'http://test.com/thumb.jpg', 'status': 1, 'msg': 'OK'},
        ],
        'respuestas': [
          {
            'id': 1,
            'denuncia_id': 1,
            'dependencia_id': 1,
            'servicio_id': 1,
            'estatu_id': 1,
            'fecha_movimiento': '2026-01-10T00:00:00',
            'observaciones': 'Revisado',
            'favorable': true,
            'fue_leida': false,
            'creadopor_id': 5,
          },
        ],
      };

      final solicitud = Solicitud.fromJson(json);

      expect(solicitud.imagenes, hasLength(1));
      expect(solicitud.imagenes?.first, isA<Imagen>());
      expect(solicitud.respuestas, hasLength(1));
      expect(solicitud.respuestas?.first, isA<Respuesta>());
    });

    test('toJson serializa correctamente sin excepciones', () {
      final json = {
        'solicitud_id': 42,
        'fecha_ingreso': '2026-03-01',
        'fecha_ultimo_estatus': '2026-03-10',
        'denuncia': 'Luminaria apagada',
        'dependencia_id': 3,
        'dependencia': 'Alumbrado',
        'servicio_id': 7,
        'servicio': 'Reparación de luminarias',
        'servicio_ultimo_estatus_id': 2,
        'servicio_ultimo_estatus': 'En proceso',
        'ultimo_estatus_id': 5,
        'ultimo_estatus': 'En proceso',
        'origen_id': 2,
        'origen': 'Web',
        'latitud': '17.9',
        'longitud': '-92.9',
        'observaciones': 'Urgente',
        'imagenes': null,
        'respuestas': null,
      };

      final solicitud = Solicitud.fromJson(json);
      final resultado = solicitud.toJson();

      expect(resultado['solicitud_id'], 42);
      expect(resultado['imagenes'], isEmpty);
      expect(resultado['respuestas'], isEmpty);
    });
  });
}

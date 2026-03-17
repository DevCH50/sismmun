// Tests unitarios para el modelo Respuesta
// Verifica parsing JSON seguro, valores por defecto y fechas
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/models/Respuesta.dart';

void main() {
  group('Respuesta.fromJson', () {
    test('parsea un JSON completo correctamente', () {
      final json = {
        'id': 10,
        'denuncia_id': 101,
        'dependencia_id': 2,
        'servicio_id': 5,
        'estatu_id': 17,
        'fecha_movimiento': '2026-03-17T14:30:00',
        'observaciones': 'Trabajo completado',
        'favorable': true,
        'fue_leida': false,
        'creadopor_id': 99,
      };

      final respuesta = Respuesta.fromJson(json);

      expect(respuesta.id, 10);
      expect(respuesta.denunciaId, 101);
      expect(respuesta.dependenciaId, 2);
      expect(respuesta.servicioId, 5);
      expect(respuesta.estatuId, 17);
      expect(respuesta.observaciones, 'Trabajo completado');
      expect(respuesta.favorable, true);
      expect(respuesta.fueLeida, false);
      expect(respuesta.creadoporId, 99);
    });

    test('usa valores por defecto cuando los campos son null', () {
      final json = <String, dynamic>{
        'id': null,
        'denuncia_id': null,
        'dependencia_id': null,
        'servicio_id': null,
        'estatu_id': null,
        'fecha_movimiento': null,
        'observaciones': null,
        'favorable': null,
        'fue_leida': null,
        'creadopor_id': null,
      };

      final respuesta = Respuesta.fromJson(json);

      expect(respuesta.id, 0);
      expect(respuesta.denunciaId, 0);
      expect(respuesta.observaciones, '');
      expect(respuesta.favorable, false);
      expect(respuesta.fueLeida, false);
    });

    test('no lanza excepción con JSON vacío', () {
      expect(() => Respuesta.fromJson({}), returnsNormally);
    });

    test('parsea la fecha correctamente', () {
      final json = {
        'id': 1,
        'denuncia_id': 1,
        'dependencia_id': 1,
        'servicio_id': 1,
        'estatu_id': 1,
        'fecha_movimiento': '2026-03-17T00:00:00',
        'observaciones': '',
        'favorable': false,
        'fue_leida': false,
        'creadopor_id': 1,
      };

      final respuesta = Respuesta.fromJson(json);

      expect(respuesta.fechaMovimiento.year, 2026);
      expect(respuesta.fechaMovimiento.month, 3);
      expect(respuesta.fechaMovimiento.day, 17);
    });

    test('toJson serializa correctamente', () {
      final json = {
        'id': 5,
        'denuncia_id': 10,
        'dependencia_id': 2,
        'servicio_id': 3,
        'estatu_id': 17,
        'fecha_movimiento': '2026-01-01T00:00:00',
        'observaciones': 'Test',
        'favorable': true,
        'fue_leida': true,
        'creadopor_id': 1,
      };

      final respuesta = Respuesta.fromJson(json);
      final resultado = respuesta.toJson();

      expect(resultado['id'], 5);
      expect(resultado['observaciones'], 'Test');
      expect(resultado['favorable'], true);
    });
  });
}

// Tests unitarios para SubirImagenRequest y TipoFoto
// Verifica construcción, valores por defecto y serialización toMap
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';

void main() {
  group('TipoFoto', () {
    test('TipoFoto.antes tiene valor "antes"', () {
      expect(TipoFoto.antes.valor, equals('antes'));
    });

    test('TipoFoto.despues tiene valor "despues"', () {
      expect(TipoFoto.despues.valor, equals('despues'));
    });

    test('TipoFoto.antes tiene etiqueta "Antes"', () {
      expect(TipoFoto.antes.etiqueta, equals('Antes'));
    });

    test('TipoFoto.despues tiene etiqueta "Después"', () {
      expect(TipoFoto.despues.etiqueta, equals('Después'));
    });
  });

  group('SubirImagenRequest', () {
    test('crea instancia con campos requeridos', () {
      final request = SubirImagenRequest(
        solicitudId: 1,
        dependenciaId: 2,
        estatusId: 17,
        servicioId: 5,
        imagenPath: '/tmp/foto.jpg',
      );

      expect(request.solicitudId, equals(1));
      expect(request.dependenciaId, equals(2));
      expect(request.estatusId, equals(17));
      expect(request.servicioId, equals(5));
      expect(request.imagenPath, equals('/tmp/foto.jpg'));
      expect(request.soloImagen, isFalse); // valor por defecto
    });

    test('campo observaciones se guarda correctamente', () {
      final request = SubirImagenRequest(
        solicitudId: 1,
        dependenciaId: 2,
        estatusId: 17,
        servicioId: 5,
        imagenPath: '/tmp/foto.jpg',
        observaciones: 'Trabajo terminado',
      );
      expect(request.observaciones, equals('Trabajo terminado'));
    });

    test('campo tipoFoto se guarda correctamente', () {
      final request = SubirImagenRequest(
        solicitudId: 1,
        dependenciaId: 2,
        estatusId: 17,
        servicioId: 5,
        imagenPath: '/tmp/foto.jpg',
        tipoFoto: TipoFoto.despues,
      );
      expect(request.tipoFoto, equals(TipoFoto.despues));
    });

    test('toMap incluye clave "observacion" (singular) para el backend', () {
      final request = SubirImagenRequest(
        solicitudId: 1,
        dependenciaId: 2,
        estatusId: 17,
        servicioId: 5,
        imagenPath: '/tmp/foto.jpg',
        observaciones: 'Test',
        tipoFoto: TipoFoto.antes,
      );
      final map = request.toMap();
      expect(map.containsKey('observacion'), isTrue,
          reason: 'El backend espera la clave "observacion" (singular)');
      expect(map['observacion'], equals('Test'));
    });

    test('toMap incluye clave "tipo_foto" con valor correcto', () {
      final request = SubirImagenRequest(
        solicitudId: 1,
        dependenciaId: 2,
        estatusId: 17,
        servicioId: 5,
        imagenPath: '/tmp/foto.jpg',
        tipoFoto: TipoFoto.despues,
      );
      final map = request.toMap();
      expect(map['tipo_foto'], equals('despues'));
    });

    test('soloImagen se serializa a "1" y "0"', () {
      final requestSolo = SubirImagenRequest(
        solicitudId: 1, dependenciaId: 2, estatusId: 17,
        servicioId: 5, imagenPath: '/tmp/foto.jpg', soloImagen: true,
      );
      final requestNoSolo = SubirImagenRequest(
        solicitudId: 1, dependenciaId: 2, estatusId: 17,
        servicioId: 5, imagenPath: '/tmp/foto.jpg', soloImagen: false,
      );
      expect(requestSolo.toMap()['solo_imagen'], equals('1'));
      expect(requestNoSolo.toMap()['solo_imagen'], equals('0'));
    });

    test('latitud y longitud null se serializan a string vacío', () {
      final request = SubirImagenRequest(
        solicitudId: 1, dependenciaId: 2, estatusId: 17,
        servicioId: 5, imagenPath: '/tmp/foto.jpg',
      );
      final map = request.toMap();
      expect(map['latitud'], equals(''));
      expect(map['longitud'], equals(''));
    });
  });
}

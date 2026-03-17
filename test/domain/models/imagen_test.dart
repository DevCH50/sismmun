// Tests unitarios para el modelo Imagen
// Verifica parsing JSON seguro y valores por defecto
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';

void main() {
  group('Imagen.fromJson', () {
    test('parsea JSON completo correctamente', () {
      final json = {
        'fecha': '2026-03-17 10:30:00',
        'url_imagen': 'https://siac.villahermosa.gob.mx/img/foto.jpg',
        'url_thumb': 'https://siac.villahermosa.gob.mx/img/thumb.jpg',
        'status': 1,
        'msg': 'Imagen subida correctamente',
      };

      final imagen = Imagen.fromJson(json);

      expect(imagen.fecha, '2026-03-17 10:30:00');
      expect(imagen.urlImagen, 'https://siac.villahermosa.gob.mx/img/foto.jpg');
      expect(imagen.urlThumb, 'https://siac.villahermosa.gob.mx/img/thumb.jpg');
      expect(imagen.status, 1);
      expect(imagen.msg, 'Imagen subida correctamente');
    });

    test('usa valores por defecto cuando los campos son null', () {
      final json = <String, dynamic>{
        'fecha': null,
        'url_imagen': null,
        'url_thumb': null,
        'status': null,
        'msg': null,
      };

      final imagen = Imagen.fromJson(json);

      expect(imagen.fecha, '');
      expect(imagen.urlImagen, '');
      expect(imagen.urlThumb, '');
      expect(imagen.status, 0);
      expect(imagen.msg, '');
    });

    test('no lanza excepción con JSON vacío', () {
      expect(() => Imagen.fromJson({}), returnsNormally);
    });

    test('status == 1 indica imagen subida con éxito', () {
      final imagen = Imagen.fromJson({'status': 1, 'msg': 'OK'});
      expect(imagen.status, 1);
    });

    test('status == 0 indica fallo al subir imagen', () {
      final imagen = Imagen.fromJson({'status': 0, 'msg': 'Error'});
      expect(imagen.status, 0);
    });

    test('toJson serializa correctamente', () {
      final imagen = Imagen(
        fecha: '2026-03-17',
        urlImagen: 'http://test.com/img.jpg',
        urlThumb: 'http://test.com/thumb.jpg',
        status: 1,
        msg: 'OK',
      );

      final json = imagen.toJson();

      expect(json['fecha'], '2026-03-17');
      expect(json['url_imagen'], 'http://test.com/img.jpg');
      expect(json['status'], 1);
    });
  });
}

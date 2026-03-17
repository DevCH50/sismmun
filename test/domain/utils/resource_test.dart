// Tests unitarios para la clase Resource y sus subtipos
// Verifica el patrón de manejo de estado de respuestas
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/utils/Resource.dart' as res;

void main() {
  group('Resource', () {
    test('Success contiene el dato correcto', () {
      final resource = res.Success<String>('datos de prueba');

      expect(resource, isA<res.Resource>());
      expect(resource.data, 'datos de prueba');
    });

    test('Error contiene el mensaje correcto', () {
      final resource = res.Error<String>('Error de conexión');

      expect(resource, isA<res.Resource>());
      expect(resource.msg, 'Error de conexión');
    });

    test('Loading es instancia de Resource', () {
      final resource = res.Loading();
      expect(resource, isA<res.Resource>());
    });

    test('Initial es instancia de Resource', () {
      final resource = res.Initial();
      expect(resource, isA<res.Resource>());
    });

    test('Warning contiene mensaje', () {
      final resource = res.Warning<String>('Advertencia importante');
      expect(resource.msg, 'Advertencia importante');
    });

    test('NoInternet es instancia de Resource', () {
      expect(res.NoInternet(), isA<res.Resource>());
    });

    test('Timeout es instancia de Resource', () {
      expect(res.Timeout(), isA<res.Resource>());
    });

    test('Unauthorized es instancia de Resource', () {
      expect(res.Unauthorized(), isA<res.Resource>());
    });

    test('Empty es instancia de Resource', () {
      expect(res.Empty(), isA<res.Resource>());
    });

    test('distinción de tipos funciona con is', () {
      final res.Resource resource = res.Success<int>(42);

      expect(resource is res.Success, true);
      expect(resource is res.Error, false);
      expect(resource is res.Loading, false);
    });

    test('Success con tipo complejo funciona correctamente', () {
      final resource = res.Success<List<int>>([1, 2, 3]);
      expect(resource.data, hasLength(3));
      expect(resource.data.first, 1);
    });
  });
}

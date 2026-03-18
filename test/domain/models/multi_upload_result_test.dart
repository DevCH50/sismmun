// Tests unitarios para el modelo MultiUploadResult
// Verifica contadores, getters y mensajes de resumen
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/models/MultiUploadResult.dart';

void main() {
  group('MultiUploadResult', () {
    group('constructores y getters básicos', () {
      test('todasExitosas retorna true cuando errores == 0', () {
        final result = MultiUploadResult(
          exitosas: 3,
          errores: 0,
          mensajesError: [],
          total: 3,
        );
        expect(result.todasExitosas, isTrue);
      });

      test('todasExitosas retorna false cuando hay errores', () {
        final result = MultiUploadResult(
          exitosas: 2,
          errores: 1,
          mensajesError: ['Error en imagen 3'],
          total: 3,
        );
        expect(result.todasExitosas, isFalse);
      });

      test('algunaExitosa retorna true cuando exitosas > 0', () {
        final result = MultiUploadResult(
          exitosas: 1,
          errores: 2,
          mensajesError: ['e1', 'e2'],
          total: 3,
        );
        expect(result.algunaExitosa, isTrue);
      });

      test('algunaExitosa retorna false cuando exitosas == 0', () {
        final result = MultiUploadResult(
          exitosas: 0,
          errores: 3,
          mensajesError: ['e1', 'e2', 'e3'],
          total: 3,
        );
        expect(result.algunaExitosa, isFalse);
      });
    });

    group('mensajeResumen', () {
      test('todas exitosas → mensaje singular cuando exitosas == 1', () {
        final result = MultiUploadResult(
          exitosas: 1,
          errores: 0,
          mensajesError: [],
          total: 1,
        );
        expect(result.mensajeResumen, contains('imagen subida'));
        expect(result.mensajeResumen, contains('1'));
      });

      test('todas exitosas → mensaje plural cuando exitosas > 1', () {
        final result = MultiUploadResult(
          exitosas: 5,
          errores: 0,
          mensajesError: [],
          total: 5,
        );
        expect(result.mensajeResumen, contains('imágenes subidas'));
        expect(result.mensajeResumen, contains('5'));
      });

      test('algunas exitosas → mensaje con conteo parcial', () {
        final result = MultiUploadResult(
          exitosas: 2,
          errores: 1,
          mensajesError: ['Error'],
          total: 3,
        );
        expect(result.mensajeResumen, contains('2'));
        expect(result.mensajeResumen, contains('3'));
        expect(result.mensajeResumen, contains('1'));
      });

      test('ninguna exitosa → mensaje de error total', () {
        final result = MultiUploadResult(
          exitosas: 0,
          errores: 3,
          mensajesError: ['e1', 'e2', 'e3'],
          total: 3,
        );
        expect(result.mensajeResumen, contains('No se pudo subir'));
      });
    });

    group('campos', () {
      test('almacena mensajesError correctamente', () {
        final errores = ['Error imagen 1', 'Error imagen 2'];
        final result = MultiUploadResult(
          exitosas: 0,
          errores: 2,
          mensajesError: errores,
          total: 2,
        );
        expect(result.mensajesError, equals(errores));
      });

      test('total refleja el número total de imágenes', () {
        final result = MultiUploadResult(
          exitosas: 3,
          errores: 2,
          mensajesError: ['e1', 'e2'],
          total: 5,
        );
        expect(result.total, equals(5));
        expect(result.exitosas + result.errores, equals(result.total));
      });
    });
  });
}

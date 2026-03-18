// Tests unitarios para AppStrings
// Verifica que los strings críticos estén definidos y no vacíos
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/core/constants/app_strings.dart';

void main() {
  group('AppStrings', () {
    test('appName no está vacío', () {
      expect(AppStrings.appName, isNotEmpty);
    });

    test('errores críticos no están vacíos', () {
      expect(AppStrings.errorNoSession, isNotEmpty);
      expect(AppStrings.errorNoUserId, isNotEmpty);
      expect(AppStrings.errorNoToken, isNotEmpty);
      expect(AppStrings.errorConnection, isNotEmpty);
      expect(AppStrings.errorTimeout, isNotEmpty);
      expect(AppStrings.errorInvalidCredentials, isNotEmpty);
    });

    test('strings de login no están vacíos', () {
      expect(AppStrings.loginTitle, isNotEmpty);
      expect(AppStrings.loginButton, isNotEmpty);
      expect(AppStrings.loginUsernameRequired, isNotEmpty);
      expect(AppStrings.loginPasswordRequired, isNotEmpty);
    });

    test('strings de imagen no están vacíos', () {
      expect(AppStrings.imagenSubiendo, isNotEmpty);
      expect(AppStrings.imagenExito, isNotEmpty);
      expect(AppStrings.imagenError, isNotEmpty);
      expect(AppStrings.imagenTipoAntes, equals('Antes'));
      expect(AppStrings.imagenTipoDespues, equals('Después'));
    });
  });
}

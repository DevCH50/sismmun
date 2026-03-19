// Tests unitarios para EliminarImagenRequest
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/models/EliminarImagenRequest.dart';

void main() {
  group('EliminarImagenRequest', () {
    test('crea el modelo con los valores correctos', () {
      const request = EliminarImagenRequest(denunciaId: 456, imagenId: 789, userId: 1);

      expect(request.denunciaId, 456);
      expect(request.imagenId, 789);
      expect(request.userId, 1);
    });

    test('toMap genera el cuerpo correcto para el backend', () {
      const request = EliminarImagenRequest(denunciaId: 10, imagenId: 20, userId: 5);

      final map = request.toMap();

      expect(map['denuncia_id'], 10);
      expect(map['imagen_id'], 20);
      expect(map['user_id'], 5);
      expect(map.length, 3);
    });

    test('toMap contiene exactamente las claves requeridas por el backend', () {
      const request = EliminarImagenRequest(denunciaId: 1, imagenId: 2, userId: 3);
      final keys = request.toMap().keys.toSet();

      expect(keys, containsAll(['denuncia_id', 'imagen_id', 'user_id']));
    });
  });
}

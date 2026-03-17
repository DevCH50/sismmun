// Tests de widget para VisorImagenesCompleto
// Verifica el visor de imágenes en pantalla completa, navegación y null safety
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/presentation/pages/home/widget/VisorImagenesCompleto.dart';

/// Crea una imagen de prueba con URL placeholder
Imagen _buildImagen({int id = 1}) => Imagen(
  fecha: '2026-03-17 10:00:0$id',
  urlImagen: 'https://picsum.photos/id/$id/400/300',
  urlThumb: 'https://picsum.photos/id/$id/80/80',
  status: 1,
  msg: 'OK',
);

/// Helper para mostrar el visor dentro de un Dialog
Widget _buildVisor({
  required List<Imagen?> imagenes,
  int indiceInicial = 0,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => VisorImagenesCompleto(
              imagenes: imagenes,
              indiceInicial: indiceInicial,
            ),
          ),
          child: const Text('Abrir visor'),
        ),
      ),
    ),
  );
}

void main() {
  group('VisorImagenesCompleto - renderización', () {
    testWidgets('muestra el botón de cerrar', (tester) async {
      await tester.pumpWidget(_buildVisor(imagenes: [_buildImagen()]));
      await tester.tap(find.text('Abrir visor'));
      await tester.pump();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('se cierra al presionar X', (tester) async {
      await tester.pumpWidget(_buildVisor(imagenes: [_buildImagen()]));
      await tester.tap(find.text('Abrir visor'));
      await tester.pump();

      expect(find.byType(VisorImagenesCompleto), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(VisorImagenesCompleto), findsNothing);
    });

    testWidgets('no muestra botones de navegación con una sola imagen', (tester) async {
      await tester.pumpWidget(_buildVisor(imagenes: [_buildImagen()]));
      await tester.tap(find.text('Abrir visor'));
      await tester.pump();

      expect(find.byIcon(Icons.chevron_left), findsNothing);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('muestra indicador de posición con múltiples imágenes', (tester) async {
      final imagenes = [_buildImagen(id: 1), _buildImagen(id: 2)];
      await tester.pumpWidget(_buildVisor(imagenes: imagenes));
      await tester.tap(find.text('Abrir visor'));
      await tester.pump();

      expect(find.text('1 / 2'), findsOneWidget);
    });

    testWidgets('no muestra indicador con una sola imagen', (tester) async {
      await tester.pumpWidget(_buildVisor(imagenes: [_buildImagen()]));
      await tester.tap(find.text('Abrir visor'));
      await tester.pump();

      expect(find.text('1 / 1'), findsNothing);
    });

    testWidgets('muestra icono de calendario en la información de fecha', (tester) async {
      await tester.pumpWidget(_buildVisor(imagenes: [_buildImagen()]));
      await tester.tap(find.text('Abrir visor'));
      await tester.pump();

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('muestra la fecha de la imagen', (tester) async {
      final imagen = Imagen(
        fecha: '2026-03-17 10:00:01',
        urlImagen: 'https://test.com/img.jpg',
        urlThumb: 'https://test.com/thumb.jpg',
        status: 1,
        msg: 'OK',
      );
      await tester.pumpWidget(_buildVisor(imagenes: [imagen]));
      await tester.tap(find.text('Abrir visor'));
      await tester.pump();

      expect(find.text('2026-03-17 10:00:01'), findsOneWidget);
    });
  });

  group('VisorImagenesCompleto - índice fuera de rango', () {
    testWidgets('no lanza excepción con índice mayor que longitud', (tester) async {
      final imagenes = [_buildImagen(id: 1)]; // Solo 1 imagen
      // Índice 5 debería ajustarse a 0 (clamp)
      expect(
        () async {
          await tester.pumpWidget(_buildVisor(imagenes: imagenes, indiceInicial: 5));
          await tester.tap(find.text('Abrir visor'));
          await tester.pump();
        },
        returnsNormally,
      );
    });

    testWidgets('no lanza excepción con imagen null en la lista', (tester) async {
      final imagenes = <Imagen?>[_buildImagen(id: 1), null];
      await tester.pumpWidget(_buildVisor(imagenes: imagenes));
      await tester.tap(find.text('Abrir visor'));
      // No debería tirar excepción
      await tester.pump();
    });
  });

  group('VisorImagenesCompleto - navegación', () {
    testWidgets('muestra botón siguiente en primera imagen con múltiples', (tester) async {
      final imagenes = [_buildImagen(id: 1), _buildImagen(id: 2), _buildImagen(id: 3)];
      await tester.pumpWidget(_buildVisor(imagenes: imagenes, indiceInicial: 0));
      await tester.tap(find.text('Abrir visor'));
      await tester.pump();

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsNothing);
    });

    testWidgets('muestra indicador correcto en página inicial', (tester) async {
      final imagenes = [_buildImagen(id: 1), _buildImagen(id: 2), _buildImagen(id: 3)];
      await tester.pumpWidget(_buildVisor(imagenes: imagenes, indiceInicial: 0));
      await tester.tap(find.text('Abrir visor'));
      await tester.pump();

      expect(find.text('1 / 3'), findsOneWidget);
    });
  });
}

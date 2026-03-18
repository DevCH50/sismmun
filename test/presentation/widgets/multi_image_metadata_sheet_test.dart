import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/presentation/pages/home/widget/MultiImageMetadataSheet.dart';

/// Helper para construir el widget con el contexto necesario
Widget buildTestWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

void main() {
  group('MultiImageMetadataResult', () {
    test('almacena todos los campos correctamente', () {
      const result = MultiImageMetadataResult(
        observaciones: 'Prueba',
        tipoFoto: TipoFoto.despues,
        imagePaths: ['/tmp/img1.jpg', '/tmp/img2.jpg'],
      );
      expect(result.observaciones, equals('Prueba'));
      expect(result.tipoFoto, equals(TipoFoto.despues));
      expect(result.imagePaths, hasLength(2));
    });

    test('imagePaths puede estar vacío', () {
      const result = MultiImageMetadataResult(
        observaciones: 'Obs',
        tipoFoto: TipoFoto.antes,
        imagePaths: [],
      );
      expect(result.imagePaths, isEmpty);
    });
  });

  group('MultiImageMetadataSheet - renderización', () {
    testWidgets('muestra el título con conteo correcto para 1 imagen',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MultiImageMetadataSheet(imagePaths: const ['/tmp/img1.jpg']),
        ),
      );
      await tester.pump();

      // Debe mostrar "1 imagen seleccionada" (singular)
      expect(find.textContaining('1'), findsWidgets);
      expect(find.textContaining('imagen seleccionada'), findsOneWidget);
    });

    testWidgets('muestra el título con conteo correcto para múltiples imágenes',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MultiImageMetadataSheet(
            imagePaths: const ['/tmp/img1.jpg', '/tmp/img2.jpg', '/tmp/img3.jpg'],
          ),
        ),
      );
      await tester.pump();

      // Debe mostrar "3 imágenes seleccionadas" (plural)
      expect(find.textContaining('3'), findsWidgets);
      expect(find.textContaining('imágenes seleccionadas'), findsOneWidget);
    });

    testWidgets('muestra el SegmentedButton con Antes y Después',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MultiImageMetadataSheet(imagePaths: const ['/tmp/img1.jpg']),
        ),
      );
      await tester.pump();

      expect(find.text('Antes'), findsOneWidget);
      expect(find.text('Después'), findsOneWidget);
    });

    testWidgets('muestra el campo de observación', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MultiImageMetadataSheet(imagePaths: const ['/tmp/img1.jpg']),
        ),
      );
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('muestra el botón Cancelar', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MultiImageMetadataSheet(imagePaths: const ['/tmp/img1.jpg']),
        ),
      );
      await tester.pump();

      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('botón Subir muestra cantidad singular para 1 imagen',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MultiImageMetadataSheet(imagePaths: const ['/tmp/img1.jpg']),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Subir 1 imagen'), findsOneWidget);
    });

    testWidgets('botón Subir muestra cantidad plural para múltiples imágenes',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MultiImageMetadataSheet(
            imagePaths: const ['/tmp/img1.jpg', '/tmp/img2.jpg'],
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Subir 2 imágenes'), findsOneWidget);
    });

    testWidgets('el tipo de foto por defecto es "Antes"', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MultiImageMetadataSheet(imagePaths: const ['/tmp/img1.jpg']),
        ),
      );
      await tester.pump();

      // El SegmentedButton de Antes debe estar seleccionado inicialmente
      final segmentedButton =
          tester.widget<SegmentedButton<TipoFoto>>(find.byType(SegmentedButton<TipoFoto>));
      expect(segmentedButton.selected, contains(TipoFoto.antes));
    });

    testWidgets('puede cambiar el tipo de foto a Después', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MultiImageMetadataSheet(imagePaths: const ['/tmp/img1.jpg']),
        ),
      );
      await tester.pump();

      // Tap en "Después"
      await tester.tap(find.text('Después'));
      await tester.pump();

      final segmentedButton =
          tester.widget<SegmentedButton<TipoFoto>>(find.byType(SegmentedButton<TipoFoto>));
      expect(segmentedButton.selected, contains(TipoFoto.despues));
    });

    testWidgets('puede escribir en el campo de observación', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MultiImageMetadataSheet(imagePaths: const ['/tmp/img1.jpg']),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Trabajo completado');
      // Avanzar el timer del scroll automático al obtener foco (300ms)
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Trabajo completado'), findsOneWidget);
    });
  });
}

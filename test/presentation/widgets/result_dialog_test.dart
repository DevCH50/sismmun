// Tests de widget para ResultDialog
// Verifica que el diálogo se muestra correctamente para cada tipo de resultado
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/presentation/widgets/ResultDialog.dart';

/// Helper para envolver el widget en un contexto de Material mínimo
Widget _buildTestApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Builder(builder: (context) => child)),
  );
}

/// Helper para mostrar el diálogo dentro de un test
Future<void> _mostrarDialogo(
  WidgetTester tester, {
  required ResultType type,
  required String message,
  String? title,
  String? buttonText,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => ResultDialog.show(
            context,
            type: type,
            message: message,
            title: title,
            buttonText: buttonText,
          ),
          child: const Text('Abrir'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Abrir'));
  await tester.pumpAndSettle();
}

void main() {
  group('ResultDialog - renderización', () {
    testWidgets('muestra el mensaje correctamente', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.success,
        message: 'Operación exitosa',
      );

      expect(find.text('Operación exitosa'), findsOneWidget);
    });

    testWidgets('muestra el título por defecto de success', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.success,
        message: 'Mensaje',
      );

      expect(find.text('Éxito'), findsOneWidget);
    });

    testWidgets('muestra el título por defecto de error', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.error,
        message: 'Algo salió mal',
      );

      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('muestra el título por defecto de warning', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.warning,
        message: 'Revisa los datos ingresados',
      );

      expect(find.text('Advertencia'), findsOneWidget);
    });

    testWidgets('muestra el título por defecto de info', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.info,
        message: 'Revisa los datos disponibles',
      );

      expect(find.text('Información'), findsOneWidget);
    });

    testWidgets('muestra título personalizado cuando se proporciona', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.success,
        message: 'Guardado',
        title: 'Título personalizado',
      );

      expect(find.text('Título personalizado'), findsOneWidget);
      expect(find.text('Éxito'), findsNothing);
    });

    testWidgets('muestra el botón "Aceptar" por defecto', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.info,
        message: 'Mensaje',
      );

      expect(find.text('Aceptar'), findsOneWidget);
    });

    testWidgets('muestra texto de botón personalizado', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.success,
        message: 'Listo',
        buttonText: 'Cerrar',
      );

      expect(find.text('Cerrar'), findsOneWidget);
      expect(find.text('Aceptar'), findsNothing);
    });

    testWidgets('se cierra al presionar el botón', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.success,
        message: 'Operación exitosa',
      );

      expect(find.byType(ResultDialog), findsOneWidget);

      await tester.tap(find.text('Aceptar'));
      await tester.pumpAndSettle();

      expect(find.byType(ResultDialog), findsNothing);
    });

    testWidgets('muestra icono correcto para success', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.success,
        message: 'OK',
      );

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('muestra icono correcto para error', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.error,
        message: 'Fallo',
      );

      expect(find.byIcon(Icons.error_rounded), findsOneWidget);
    });

    testWidgets('muestra icono correcto para warning', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.warning,
        message: 'Cuidado',
      );

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('muestra icono correcto para info', (tester) async {
      await _mostrarDialogo(
        tester,
        type: ResultType.info,
        message: 'Nota',
      );

      expect(find.byIcon(Icons.info_rounded), findsOneWidget);
    });
  });

  group('ResultTypeExtension', () {
    // Los colores ahora dependen del ColorScheme del tema.
    // Se verifica que resolveColor/resolveColorContainer/resolveOnColor
    // devuelvan valores coherentes con el esquema dado.
    test('success resuelve color de tertiary', () {
      const cs = ColorScheme.light();
      expect(ResultType.success.resolveColor(cs), cs.tertiary);
    });

    test('error resuelve color de error', () {
      const cs = ColorScheme.light();
      expect(ResultType.error.resolveColor(cs), cs.error);
    });

    test('warning resuelve color de primary', () {
      const cs = ColorScheme.light();
      expect(ResultType.warning.resolveColor(cs), cs.primary);
    });

    test('info resuelve color de secondary', () {
      const cs = ColorScheme.light();
      expect(ResultType.info.resolveColor(cs), cs.secondary);
    });

    test('resolveColorContainer devuelve tertiaryContainer para success', () {
      const cs = ColorScheme.light();
      expect(ResultType.success.resolveColorContainer(cs), cs.tertiaryContainer);
    });

    test('resolveOnColor devuelve onError para error', () {
      const cs = ColorScheme.light();
      expect(ResultType.error.resolveOnColor(cs), cs.onError);
    });

    test('success tiene título "Éxito"', () {
      expect(ResultType.success.defaultTitle, 'Éxito');
    });

    test('error tiene título "Error"', () {
      expect(ResultType.error.defaultTitle, 'Error');
    });

    test('warning tiene título "Advertencia"', () {
      expect(ResultType.warning.defaultTitle, 'Advertencia');
    });

    test('info tiene título "Información"', () {
      expect(ResultType.info.defaultTitle, 'Información');
    });
  });
}

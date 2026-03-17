// Tests de widget para PrimaryElevatedButton
// Verifica renderización, color personalizable y callback onPressed
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/presentation/widgets/PrimaryElevatedButton.dart';

Widget _buildButton({
  String text = 'Presionar',
  Color color = Colors.blue,
  VoidCallback? onPressed,
}) {
  return MaterialApp(
    home: Scaffold(
      body: PrimaryElevatedButton(
        text: text,
        color: color,
        onPressed: onPressed ?? () {},
      ),
    ),
  );
}

void main() {
  group('PrimaryElevatedButton - renderización', () {
    testWidgets('muestra el texto correctamente', (tester) async {
      await tester.pumpWidget(_buildButton(text: 'Iniciar Sesión'));
      expect(find.text('Iniciar Sesión'), findsOneWidget);
    });

    testWidgets('es un ElevatedButton', (tester) async {
      await tester.pumpWidget(_buildButton());
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renderiza sin errores con diferentes textos', (tester) async {
      for (final texto in ['Guardar', 'Cancelar', 'Enviar', 'Aceptar']) {
        await tester.pumpWidget(_buildButton(text: texto));
        expect(find.text(texto), findsOneWidget);
      }
    });
  });

  group('PrimaryElevatedButton - interacción', () {
    testWidgets('llama onPressed cuando se presiona', (tester) async {
      bool presionado = false;
      await tester.pumpWidget(_buildButton(onPressed: () => presionado = true));

      await tester.tap(find.byType(ElevatedButton));
      expect(presionado, true);
    });

    testWidgets('puede presionarse múltiples veces', (tester) async {
      int conteo = 0;
      await tester.pumpWidget(_buildButton(onPressed: () => conteo++));

      await tester.tap(find.byType(ElevatedButton));
      await tester.tap(find.byType(ElevatedButton));
      await tester.tap(find.byType(ElevatedButton));

      expect(conteo, 3);
    });
  });
}

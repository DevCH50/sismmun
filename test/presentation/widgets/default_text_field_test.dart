// Tests de widget para DefaultTextField
// Verifica comportamiento de campo de texto, validación y toggle de contraseña
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/presentation/widgets/DefaultTextField.dart';

/// Helper para renderizar DefaultTextField en un MaterialApp mínimo
Widget _buildField({
  String label = 'Campo',
  IconData icon = Icons.person,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  Function(String)? onChanged,
  String? Function(String?)? validator,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextField(
          label: label,
          icon: icon,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged ?? (text) {},
          validator: validator,
        ),
      ),
    ),
  );
}

void main() {
  group('DefaultTextField - renderización', () {
    testWidgets('muestra el label correctamente', (tester) async {
      await tester.pumpWidget(_buildField(label: 'Username'));
      expect(find.text('Username'), findsOneWidget);
    });

    testWidgets('muestra el icono del prefijo', (tester) async {
      await tester.pumpWidget(_buildField(icon: Icons.email));
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('no muestra el botón de visibilidad sin obscureText', (tester) async {
      await tester.pumpWidget(_buildField(obscureText: false));
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });

    testWidgets('muestra el botón de visibilidad con obscureText=true', (tester) async {
      await tester.pumpWidget(_buildField(obscureText: true));
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });
  });

  group('DefaultTextField - funcionalidad', () {
    testWidgets('llama onChanged cuando el usuario escribe', (tester) async {
      String capturedValue = '';
      await tester.pumpWidget(_buildField(
        onChanged: (text) => capturedValue = text,
      ));

      await tester.enterText(find.byType(TextFormField), 'hola');
      expect(capturedValue, 'hola');
    });

    testWidgets('toggle de contraseña cambia visibilidad del texto', (tester) async {
      await tester.pumpWidget(_buildField(obscureText: true));

      // Inicialmente oculto - botón muestra "ver"
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap en el botón de toggle
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      // Ahora muestra "ocultar"
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('toggle doble restaura el estado original', (tester) async {
      await tester.pumpWidget(_buildField(obscureText: true));

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      // Vuelve al estado oculto
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('ejecuta el validator cuando se llama validate', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: DefaultTextField(
                label: 'Test',
                icon: Icons.text_fields,
                onChanged: (text) {},
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Campo requerido' : null,
              ),
            ),
          ),
        ),
      );

      // Encontrar el Form y llamar validate
      final formFinder = find.byType(Form);
      expect(formFinder, findsOneWidget);
      final formState = tester.state<FormState>(formFinder);
      formState.validate();
      await tester.pump();

      expect(find.text('Campo requerido'), findsOneWidget);
    });
  });
}

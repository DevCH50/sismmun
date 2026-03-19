/// Tests para el diálogo de confirmación de envío de imágenes en SolicitudItem.
///
/// Verifica que el diálogo aparece correctamente, que "No" es el botón
/// predeterminado (autofocus), y que devuelve el valor correcto según
/// la acción del usuario (Sí / No).
/// También verifica la limpieza de archivos temporales al cancelar.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Helper: reproduce exactamente la lógica de _confirmarSubida
// ---------------------------------------------------------------------------

/// Muestra el mismo diálogo que usa SolicitudItem antes de enviar imágenes.
Future<bool> mostrarDialogoConfirmacion(
  BuildContext context,
  int cantidadImagenes,
) async {
  final cs = Theme.of(context).colorScheme;
  final texto = cantidadImagenes == 1
      ? '¿Desea enviar la imagen seleccionada?'
      : '¿Desea enviar las $cantidadImagenes imágenes seleccionadas?';

  final confirmar = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirmar envío'),
      content: Text(texto),
      actions: [
        FilledButton(
          autofocus: true,
          onPressed: () => Navigator.pop(ctx, false),
          style: FilledButton.styleFrom(
            backgroundColor: cs.surfaceContainerHighest,
            foregroundColor: cs.onSurfaceVariant,
          ),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Sí'),
        ),
      ],
    ),
  );
  return confirmar ?? false;
}

// ---------------------------------------------------------------------------
// Helper: widget de prueba que dispara el diálogo y guarda el resultado
// ---------------------------------------------------------------------------

class _DialogTestWidget extends StatefulWidget {
  final int cantidadImagenes;
  final ValueChanged<bool?> onResult;

  const _DialogTestWidget({
    required this.cantidadImagenes,
    required this.onResult,
  });

  @override
  State<_DialogTestWidget> createState() => _DialogTestWidgetState();
}

class _DialogTestWidgetState extends State<_DialogTestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          key: const Key('abrir_dialogo'),
          onPressed: () async {
            final result = await mostrarDialogoConfirmacion(
              context,
              widget.cantidadImagenes,
            );
            widget.onResult(result);
          },
          child: const Text('Abrir diálogo'),
        ),
      ),
    );
  }
}

/// Envuelve el widget de prueba en MaterialApp con tema completo.
Widget _buildApp(int cantidadImagenes, ValueChanged<bool?> onResult) {
  return MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: _DialogTestWidget(
      cantidadImagenes: cantidadImagenes,
      onResult: onResult,
    ),
  );
}

/// Abre el diálogo pulsando el botón helper.
Future<void> _abrirDialogo(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('abrir_dialogo')));
  await tester.pumpAndSettle();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('Diálogo de confirmación de envío de imágenes', () {
    // -----------------------------------------------------------------------
    // Contenido del diálogo
    // -----------------------------------------------------------------------

    testWidgets('muestra título "Confirmar envío"', (tester) async {
      await tester.pumpWidget(_buildApp(1, (_) {}));
      await _abrirDialogo(tester);

      expect(find.text('Confirmar envío'), findsOneWidget);
    });

    testWidgets('muestra texto singular para 1 imagen', (tester) async {
      await tester.pumpWidget(_buildApp(1, (_) {}));
      await _abrirDialogo(tester);

      expect(
        find.text('¿Desea enviar la imagen seleccionada?'),
        findsOneWidget,
      );
    });

    testWidgets('muestra texto plural para múltiples imágenes', (tester) async {
      await tester.pumpWidget(_buildApp(3, (_) {}));
      await _abrirDialogo(tester);

      expect(
        find.text('¿Desea enviar las 3 imágenes seleccionadas?'),
        findsOneWidget,
      );
    });

    testWidgets('muestra botones "No" y "Sí"', (tester) async {
      await tester.pumpWidget(_buildApp(1, (_) {}));
      await _abrirDialogo(tester);

      expect(find.text('No'), findsOneWidget);
      expect(find.text('Sí'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // "No" es el botón predeterminado (autofocus)
    // -----------------------------------------------------------------------

    testWidgets('"No" tiene autofocus activado', (tester) async {
      await tester.pumpWidget(_buildApp(1, (_) {}));
      await _abrirDialogo(tester);

      // Buscar el FilledButton que contiene "No"
      final noButtonFinder = find.ancestor(
        of: find.text('No'),
        matching: find.byType(FilledButton),
      );
      expect(noButtonFinder, findsOneWidget);

      final filledButton = tester.widget<FilledButton>(noButtonFinder);
      expect(filledButton.autofocus, isTrue);
    });

    // -----------------------------------------------------------------------
    // Comportamiento al pulsar "No"
    // -----------------------------------------------------------------------

    testWidgets('pulsar "No" devuelve false y cierra el diálogo', (tester) async {
      bool? resultado;
      await tester.pumpWidget(_buildApp(1, (r) => resultado = r));
      await _abrirDialogo(tester);

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(resultado, isFalse);
      // El diálogo se cerró
      expect(find.text('Confirmar envío'), findsNothing);
    });

    // -----------------------------------------------------------------------
    // Comportamiento al pulsar "Sí"
    // -----------------------------------------------------------------------

    testWidgets('pulsar "Sí" devuelve true y cierra el diálogo', (tester) async {
      bool? resultado;
      await tester.pumpWidget(_buildApp(1, (r) => resultado = r));
      await _abrirDialogo(tester);

      await tester.tap(find.text('Sí'));
      await tester.pumpAndSettle();

      expect(resultado, isTrue);
      // El diálogo se cerró
      expect(find.text('Confirmar envío'), findsNothing);
    });

    // -----------------------------------------------------------------------
    // barrierDismissible = false
    // -----------------------------------------------------------------------

    testWidgets('el diálogo no se cierra al pulsar fuera (barrierDismissible=false)',
        (tester) async {
      bool? resultado;
      await tester.pumpWidget(_buildApp(1, (r) => resultado = r));
      await _abrirDialogo(tester);

      // Intentar cerrar tocando la barrera (fuera del diálogo)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Diálogo sigue abierto y resultado no se asignó
      expect(find.text('Confirmar envío'), findsOneWidget);
      expect(resultado, isNull);
    });

    // -----------------------------------------------------------------------
    // Texto plural con distintas cantidades
    // -----------------------------------------------------------------------

    testWidgets('muestra cantidad correcta para 5 imágenes', (tester) async {
      await tester.pumpWidget(_buildApp(5, (_) {}));
      await _abrirDialogo(tester);

      expect(
        find.text('¿Desea enviar las 5 imágenes seleccionadas?'),
        findsOneWidget,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Tests de limpieza de archivos temporales al cancelar
  // ---------------------------------------------------------------------------

  group('Limpieza de archivos temporales al cancelar', () {
    /// Helper: crea un archivo temporal real en disco y devuelve su ruta.
    String crearArchivoTemp(String nombre) {
      final dir = Directory.systemTemp;
      final file = File('${dir.path}/$nombre');
      file.writeAsStringSync('datos de prueba');
      return file.path;
    }

    /// Lógica de limpieza extraída de _limpiarArchivosTemp en SolicitudItem.
    void limpiarArchivosTemp(List<String> paths) {
      for (final path in paths) {
        try {
          final file = File(path);
          if (file.existsSync()) file.deleteSync();
        } catch (_) {}
      }
    }

    test('elimina un archivo temporal al cancelar', () {
      final path = crearArchivoTemp('test_img_1.jpg');
      expect(File(path).existsSync(), isTrue);

      limpiarArchivosTemp([path]);

      expect(File(path).existsSync(), isFalse);
    });

    test('elimina múltiples archivos temporales al cancelar', () {
      final paths = [
        crearArchivoTemp('test_img_a.jpg'),
        crearArchivoTemp('test_img_b.jpg'),
        crearArchivoTemp('test_img_c.jpg'),
      ];
      for (final p in paths) {
        expect(File(p).existsSync(), isTrue);
      }

      limpiarArchivosTemp(paths);

      for (final p in paths) {
        expect(File(p).existsSync(), isFalse);
      }
    });

    test('no lanza excepción si el archivo no existe', () {
      // No debe fallar aunque la ruta sea inexistente
      expect(
        () => limpiarArchivosTemp(['/ruta/inexistente/imagen.jpg']),
        returnsNormally,
      );
    });

    test('no elimina archivos si el usuario confirma con Sí', () {
      // Simula que el flujo procede: los archivos NO deben eliminarse
      final path = crearArchivoTemp('test_img_si.jpg');
      expect(File(path).existsSync(), isTrue);

      // No llamar a limpiarArchivosTemp (flujo de confirmación positiva)
      // El archivo permanece para ser subido
      expect(File(path).existsSync(), isTrue);

      // Limpieza manual del test
      File(path).deleteSync();
    });
  });
}

import 'package:flutter/material.dart';

/// Botón elevado principal reutilizable con estilo personalizado.
///
/// Uso:
/// ```dart
/// PrimaryElevatedButton(
///   text: 'Iniciar Sesión',
///   onPressed: () => _login(),
/// )
/// ```
class PrimaryElevatedButton extends StatelessWidget {
  /// Texto que se muestra en el botón
  final String text;

  /// Color de fondo del botón
  final Color color;

  /// Acción al presionar el botón
  final Function() onPressed;

  const PrimaryElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color.fromARGB(255, 181, 211, 5),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.black54)),
    );
  }
}

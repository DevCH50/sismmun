import 'package:flutter/material.dart';

/// Widget que muestra el estado de error al cargar la lista de solicitudes.
///
/// Parámetros:
/// - [errorMessage]: Mensaje de error a mostrar al usuario.
/// - [onReintentar]: Callback que se ejecuta cuando el usuario pulsa "Reintentar".
class HomeErrorWidget extends StatelessWidget {
  /// Mensaje de error proveniente del estado del bloc.
  final String errorMessage;

  /// Callback para reintentar la carga de solicitudes.
  final VoidCallback onReintentar;

  const HomeErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade700),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

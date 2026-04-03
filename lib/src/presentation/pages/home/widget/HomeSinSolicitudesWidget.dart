import 'package:flutter/material.dart';

/// Widget que muestra el estado vacío cuando no hay solicitudes registradas.
///
/// Parámetros:
/// - [onActualizar]: Callback que se ejecuta cuando el usuario pulsa "Actualizar".
class HomeSinSolicitudesWidget extends StatelessWidget {
  /// Callback para refrescar la lista de solicitudes.
  final VoidCallback onActualizar;

  const HomeSinSolicitudesWidget({
    super.key,
    required this.onActualizar,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: cs.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay Solicitudes registradas',
            style: TextStyle(fontSize: 16, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onActualizar,
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }
}

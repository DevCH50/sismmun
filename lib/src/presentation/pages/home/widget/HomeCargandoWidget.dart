import 'package:flutter/material.dart';

/// Widget que muestra el estado de carga de la lista de solicitudes.
/// Presenta un indicador de progreso circular y un texto informativo
/// centrados en pantalla sobre el fondo degradado de la home.
class HomeCargandoWidget extends StatelessWidget {
  const HomeCargandoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Cargando Solicitudes...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

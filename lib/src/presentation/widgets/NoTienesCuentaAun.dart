import 'package:flutter/material.dart';

class NoTienesCuentaAun extends StatelessWidget {
  final Color color;
  final String mensaje;
  final String titulo;
  final IconData icono;

  const NoTienesCuentaAun({
    super.key,
    required this.color,
    required this.mensaje,
    required this.titulo,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    ),
                    child: Builder(builder: (context) {
                      final cs = Theme.of(context).colorScheme;
                      return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icono, size: 60, color: color),
                        const SizedBox(height: 16),
                        Text(
                          '¡Atención!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          mensaje,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: cs.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Entendido',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: cs.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                      );
                    }),
                  ),
                );
              },
            );
          },
          child: Builder(builder: (context) {
            final onBg = Theme.of(context).colorScheme.onInverseSurface;
            return Text(
              titulo,
              style: TextStyle(
                color: onBg,
                fontSize: 18,
                decoration: TextDecoration.underline,
                decorationColor: onBg,
              ),
            );
          }),
        ),
      ],
    );
  }
}

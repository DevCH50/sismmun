import 'package:flutter/material.dart';

import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/presentation/pages/home/widget/SolicitudMiniatura.dart';

/// Widget que muestra la galería horizontal de imágenes de una solicitud.
///
/// Incluye:
/// - Etiqueta con el conteo de imágenes y un ícono de biblioteca.
/// - Botón "+ Imagen" para agregar una nueva foto.
/// - Lista horizontal de [SolicitudMiniatura] con scroll.
///
/// Es un [StatelessWidget] puro: toda la lógica de estado y de subida
/// reside en el padre ([SolicitudItem]).
class SolicitudGaleria extends StatelessWidget {
  /// Lista de imágenes de la solicitud (puede contener nulos del modelo).
  final List<Imagen?> imagenes;

  /// Indica si hay una subida en curso para deshabilitar el botón agregar.
  final bool isUploading;

  /// Callback invocado cuando el usuario presiona "+ Imagen".
  final VoidCallback onAgregarImagen;

  /// Callback invocado cuando el usuario toca una miniatura de imagen.
  /// Recibe el índice en [imagenes] para abrir el visor en la posición correcta.
  final void Function(int index) onVerImagen;

  const SolicitudGaleria({
    super.key,
    required this.imagenes,
    required this.isUploading,
    required this.onAgregarImagen,
    required this.onVerImagen,
  });

  // ---------------------------------------------------------------------------
  // Sub-widgets internos
  // ---------------------------------------------------------------------------

  /// Etiqueta que muestra la cantidad de imágenes con ícono de biblioteca.
  Widget _buildEtiquetaImagenes(ColorScheme cs) {
    final int cantidad = imagenes.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.photo_library, size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            '$cantidad ${cantidad == 1 ? 'imagen' : 'imágenes'}',
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Botón compacto para agregar una imagen adicional.
  Widget _buildBotonAgregar(ColorScheme cs) {
    return TextButton.icon(
      onPressed: isUploading ? null : onAgregarImagen,
      icon: const Icon(Icons.add_photo_alternate, size: 16),
      label: const Text('+ Imagen'),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        foregroundColor: cs.primary,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: etiqueta de conteo + botón agregar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEtiquetaImagenes(cs),
              _buildBotonAgregar(cs),
            ],
          ),

          // Scroll horizontal de miniaturas
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imagenes.length,
              itemBuilder: (_, index) {
                final imagen = imagenes[index];
                if (imagen == null) return const SizedBox.shrink();
                return SolicitudMiniatura(
                  imagen: imagen,
                  onTap: () => onVerImagen(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

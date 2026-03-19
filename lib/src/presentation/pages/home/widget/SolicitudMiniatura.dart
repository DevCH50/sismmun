import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sismmun/src/core/constants/app_strings.dart';
import 'package:sismmun/src/data/api/ApiConfig.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';

/// Widget que muestra una miniatura de imagen o ícono PDF.
///
/// Al tocar una imagen abre el callback [onTap] (el visor completo).
/// Al tocar un PDF muestra un bottom sheet con opciones: abrir o compartir.
class SolicitudMiniatura extends StatelessWidget {
  /// La imagen a mostrar (nunca nula al llegar aquí).
  final Imagen imagen;

  /// Callback invocado cuando se toca la miniatura de imagen (no PDF).
  final VoidCallback onTap;

  /// Callback opcional para eliminar la imagen. Si es nulo el botón no se muestra.
  final VoidCallback? onEliminar;

  const SolicitudMiniatura({
    super.key,
    required this.imagen,
    required this.onTap,
    this.onEliminar,
  });

  // ---------------------------------------------------------------------------
  // Helpers: detección de tipo
  // ---------------------------------------------------------------------------

  /// Devuelve `true` si la URL corresponde a un archivo PDF.
  bool _esPdf(String url) => url.toLowerCase().endsWith('.pdf');

  // ---------------------------------------------------------------------------
  // Métodos para PDF
  // ---------------------------------------------------------------------------

  /// Muestra un bottom sheet con opciones para el PDF (abrir o compartir).
  void _mostrarOpcionesPdf(BuildContext context, String url) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text(AppStrings.imagenPdfAbrir),
              onTap: () {
                Navigator.pop(ctx);
                _abrirPdf(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text(AppStrings.imagenPdfCompartir),
              onTap: () {
                Navigator.pop(ctx);
                _compartirPdf(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text(AppStrings.cancelar),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  /// Abre el PDF en el navegador o en una aplicación externa.
  Future<void> _abrirPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Comparte el enlace del PDF usando el sistema operativo.
  Future<void> _compartirPdf(String url) async {
    await Share.share(url, subject: 'Documento PDF');
  }

  // ---------------------------------------------------------------------------
  // Sub-widgets de estado
  // ---------------------------------------------------------------------------

  /// Icono decorativo que representa un archivo PDF.
  Widget _buildPdfIcon(ColorScheme cs) {
    return Container(
      color: cs.errorContainer,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, color: cs.error, size: 32),
            const SizedBox(height: 4),
            Text(
              AppStrings.imagenPdfEtiqueta,
              style: TextStyle(
                fontSize: 10,
                color: cs.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget de sustitución cuando la imagen no pudo cargarse.
  Widget _buildErrorImagen(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: cs.onSurfaceVariant, size: 24),
          const SizedBox(height: 4),
          Text(
            'Error',
            style: TextStyle(fontSize: 8, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  /// Etiqueta legible del tipo de foto ("Antes" / "Después").
  String get _etiquetaTipo {
    final tipo = imagen.tipoFoto.trim().toLowerCase();
    if (tipo == 'despues' || tipo == 'después') return 'Después';
    if (tipo == 'antes') return 'Antes';
    return tipo.isNotEmpty ? tipo : '';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bool esPdf =
        _esPdf(imagen.urlThumb) || _esPdf(imagen.urlImagen);
    final String etiqueta = _etiquetaTipo;

    // Color semántico de la etiqueta según tipo_foto
    final Color colorEtiqueta = () {
      final tipo = imagen.tipoFoto.trim().toLowerCase();
      if (tipo == 'despues' || tipo == 'después') return cs.primary;
      if (tipo == 'antes') return cs.secondary;
      return cs.onSurface;
    }();

    return GestureDetector(
      onTap: esPdf
          ? () => _mostrarOpcionesPdf(context, imagen.urlImagen)
          : onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cs.outlineVariant, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Imagen o ícono PDF
              SizedBox(
                width: 80,
                height: 80,
                child: esPdf
                    ? _buildPdfIcon(cs)
                    : Image.network(
                        ApiConfig.fixImageUrl(imagen.urlThumb),
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, _) => _buildErrorImagen(cs),
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.primary,
                            ),
                          );
                        },
                      ),
              ),

              // Etiqueta tipo_foto en la parte inferior
              if (etiqueta.isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: colorEtiqueta.withValues(alpha: 0.85),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      etiqueta,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.onPrimary,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Botón eliminar (esquina superior derecha)
              // Visible solo si el backend indica que la imagen es eliminable.
              if (onEliminar != null && imagen.isEliminable)
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: onEliminar,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: cs.errorContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 13,
                        color: cs.onErrorContainer,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

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

  const SolicitudMiniatura({
    super.key,
    required this.imagen,
    required this.onTap,
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
              title: const Text('Abrir PDF'),
              onTap: () {
                Navigator.pop(ctx);
                _abrirPdf(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Compartir'),
              onTap: () {
                Navigator.pop(ctx);
                _compartirPdf(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancelar'),
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
  Widget _buildPdfIcon() {
    return Container(
      color: Colors.red.shade50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.red.shade700, size: 32),
            const SizedBox(height: 4),
            Text(
              'PDF',
              style: TextStyle(
                fontSize: 10,
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget de sustitución cuando la imagen no pudo cargarse.
  Widget _buildErrorImagen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image, color: Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(
            'Error',
            style: TextStyle(fontSize: 8, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bool esPdf =
        _esPdf(imagen.urlThumb) || _esPdf(imagen.urlImagen);

    return GestureDetector(
      onTap: esPdf
          ? () => _mostrarOpcionesPdf(context, imagen.urlImagen)
          : onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: esPdf
              ? _buildPdfIcon()
              : Image.network(
                  ApiConfig.fixImageUrl(imagen.urlThumb),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildErrorImagen(),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

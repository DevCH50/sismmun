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

  /// Etiqueta legible del tipo de foto ("Antes" / "Después").
  String get _etiquetaTipo {
    final tipo = imagen.tipoFoto.trim().toLowerCase();
    if (tipo == 'despues' || tipo == 'después') return 'Después';
    if (tipo == 'antes') return 'Antes';
    return tipo.isNotEmpty ? tipo : '';
  }

  /// Color de fondo de la etiqueta según el tipo.
  Color get _colorEtiqueta {
    final tipo = imagen.tipoFoto.trim().toLowerCase();
    if (tipo == 'despues' || tipo == 'después') return Colors.green.shade700;
    if (tipo == 'antes') return Colors.orange.shade700;
    return Colors.black54;
  }

  @override
  Widget build(BuildContext context) {
    final bool esPdf =
        _esPdf(imagen.urlThumb) || _esPdf(imagen.urlImagen);
    final String etiqueta = _etiquetaTipo;

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
          child: Stack(
            children: [
              // Imagen o ícono PDF
              SizedBox(
                width: 80,
                height: 80,
                child: esPdf
                    ? _buildPdfIcon()
                    : Image.network(
                        ApiConfig.fixImageUrl(imagen.urlThumb),
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, _) => _buildErrorImagen(),
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
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
                    color: _colorEtiqueta.withValues(alpha: 0.85),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      etiqueta,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
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

import 'package:flutter/material.dart';

/// Widget especializado para visualizar imágenes en pantalla completa
/// con navegación entre múltiples imágenes
class VisorImagenesCompleto extends StatefulWidget {
  final List<dynamic> imagenes;
  final int indiceInicial;

  const VisorImagenesCompleto({
    super.key,
    required this.imagenes,
    required this.indiceInicial,
  });

  @override
  State<VisorImagenesCompleto> createState() => _VisorImagenesCompletoState();
}

class _VisorImagenesCompletoState extends State<VisorImagenesCompleto> {
  late PageController _pageController;
  late int _indiceActual;

  @override
  void initState() {
    super.initState();
    _indiceActual = widget.indiceInicial;
    _pageController = PageController(initialPage: widget.indiceInicial);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // PageView para navegar entre imágenes
          _buildPageView(),

          // Botón para cerrar (esquina superior derecha)
          _buildBotonCerrar(),

          // Indicador de posición (esquina superior izquierda)
          if (widget.imagenes.length > 1) _buildIndicadorPosicion(),

          // Botones de navegación (izquierda y derecha)
          if (widget.imagenes.length > 1) ..._buildBotonesNavegacion(),

          // Información de la fecha (parte inferior)
          _buildInfoFecha(),
        ],
      ),
    );
  }

  /// Construye el PageView con las imágenes
  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.imagenes.length,
      onPageChanged: (index) {
        setState(() {
          _indiceActual = index;
        });
      },
      itemBuilder: (context, index) {
        final imagen = widget.imagenes[index];
        return Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(
              imagen!.urlImagen,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, color: Colors.white, size: 64),
                        SizedBox(height: 8),
                        Text(
                          'Error al cargar la imagen',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade800,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Construye el botón de cerrar
  Widget _buildBotonCerrar() {
    return Positioned(
      top: 16,
      right: 16,
      child: IconButton(
        icon: const Icon(Icons.close, color: Colors.white, size: 30),
        style: IconButton.styleFrom(
          backgroundColor: Colors.black54,
          padding: const EdgeInsets.all(8),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Construye el indicador de posición
  Widget _buildIndicadorPosicion() {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${_indiceActual + 1} / ${widget.imagenes.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Construye los botones de navegación
  List<Widget> _buildBotonesNavegacion() {
    return [
      // Botón anterior
      if (_indiceActual > 0)
        Positioned(
          left: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white, size: 40),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: const EdgeInsets.all(8),
              ),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ),

      // Botón siguiente
      if (_indiceActual < widget.imagenes.length - 1)
        Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white, size: 40),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: const EdgeInsets.all(8),
              ),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ),
    ];
  }

  /// Construye la información de fecha
  Widget _buildInfoFecha() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text(
                widget.imagenes[_indiceActual]!.fecha,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

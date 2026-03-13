import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sismmun/src/domain/models/Solicitud.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeBloc.dart';
import 'package:sismmun/src/presentation/pages/home/widget/VisorImagenesCompleto.dart';
import 'package:sismmun/src/presentation/pages/home/widget/ImageUploaderHelper.dart';
import 'package:sismmun/src/presentation/pages/home/widget/ImageMetadataSheet.dart';
import 'package:sismmun/src/presentation/widgets/ResultDialog.dart';

/// Widget que representa una solicitud en la lista
class SolicitudItem extends StatefulWidget {
  final Solicitud solicitud;
  final VoidCallback? onImageUploaded;
  final HomeBloc bloc;

  const SolicitudItem({
    super.key,
    required this.solicitud,
    this.onImageUploaded,
    required this.bloc,
  });

  @override
  State<SolicitudItem> createState() => _SolicitudItemState();
}

class _SolicitudItemState extends State<SolicitudItem> {
  final ImageUploaderHelper _imageUploader = ImageUploaderHelper();
  bool _isUploading = false;
  List<Imagen?> _imagenesLocales = [];

  @override
  void initState() {
    super.initState();
   _imagenesLocales = List.from(widget.solicitud.imagenes ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSolicitudId(),
            const SizedBox(height: 4),
            _buildTitulo(),
            const SizedBox(height: 4),
            _buildServicio(),
            if (_imagenesLocales.isNotEmpty) _buildGaleriaImagenes(),
            if (_imagenesLocales.isEmpty) _buildBotonAgregarImagen(),
            _buildBotonMarcarAtendida(),
          ],
        ),
      ),
    );
  }

  /// Construye el título de la solicitud
  Widget _buildSolicitudId() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.solicitud.fechaIngreso,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          widget.solicitud.solicitudId.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildTitulo() {
    return Text(
      widget.solicitud.denuncia,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        decoration: widget.solicitud.denuncia != ''
            ? null
            : TextDecoration.lineThrough,
      ),
    );
  }

  /// Construye la información del servicio
  Widget _buildServicio() {
    return Text(
      widget.solicitud.servicio,
      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
    );
  }

  /// Botón para agregar imagen cuando no hay imágenes
  Widget _buildBotonAgregarImagen() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextButton.icon(
        onPressed: _isUploading ? null : _agregarImagen,
        icon: const Icon(Icons.add_photo_alternate, size: 18),
        label: const Text('+ Imagen'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          foregroundColor: Colors.blue.shade700,
        ),
      ),
    );
  }

  /// Construye la galería de imágenes en scroll horizontal
  Widget _buildGaleriaImagenes() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta con cantidad de imágenes y botón agregar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEtiquetaImagenes(),
              TextButton.icon(
                onPressed: _isUploading ? null : _agregarImagen,
                icon: const Icon(Icons.add_photo_alternate, size: 16),
                label: const Text('+ Imagen'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  foregroundColor: Colors.blue.shade700,
                ),
              ),
            ],
          ),

          // Scroll horizontal de miniaturas
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imagenesLocales.length,
              itemBuilder: (context, index) => _buildMiniatura(index),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la etiqueta que indica la cantidad de imágenes
  Widget _buildEtiquetaImagenes() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.photo_library, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            '${_imagenesLocales.length} ${_imagenesLocales.length == 1 ? 'imagen' : 'imágenes'}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Verifica si la URL es un PDF
  bool _esPdf(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  /// Construye una miniatura de imagen o icono de PDF
  Widget _buildMiniatura(int index) {
    final imagen = _imagenesLocales[index];
    final bool esPdf = _esPdf(imagen!.urlThumb) || _esPdf(imagen.urlImagen);

    return GestureDetector(
      onTap: () => esPdf ? _mostrarOpcionesPdf(imagen.urlImagen) : _mostrarImagenCompleta(index),
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: esPdf ? _buildPdfIcon() : Image.network(
            imagen.urlThumb,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildErrorImagen(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Muestra modal con opciones para PDF (abrir o compartir)
  void _mostrarOpcionesPdf(String url) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text('Abrir PDF'),
              onTap: () {
                Navigator.pop(context);
                _abrirPdf(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Compartir'),
              onTap: () {
                Navigator.pop(context);
                _compartirPdf(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancelar'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Abre el PDF en el navegador o app externa
  Future<void> _abrirPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Comparte el enlace del PDF
  Future<void> _compartirPdf(String url) async {
    await Share.share(url, subject: 'Documento PDF');
  }

  /// Construye el icono de PDF
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
              style: TextStyle(fontSize: 10, color: Colors.red.shade700, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el widget de error de carga de imagen
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

  /// Construye el botón para marcar como atendida
  Widget _buildBotonMarcarAtendida() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _isUploading ? null : _marcarComoAtendida,
          icon: _isUploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_circle_outline),
          label: Text(
            _isUploading ? 'Subiendo imagen...' : 'Marcar como Atendida',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  /// Agrega una imagen sin cambiar el estatus (soloImagen = true)
  /// Solicita observación y tipo de foto (Antes/Después) antes de subir
  Future<void> _agregarImagen() async {
    // Paso 1: Seleccionar origen de la imagen
    final origen = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tomar Foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de Galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancelar'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );

    if (origen == null) return;

    // Paso 2: Capturar/seleccionar la imagen
    final picker = ImagePicker();
    final XFile? imagenSeleccionada = await picker.pickImage(
      source: origen,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (imagenSeleccionada == null || !mounted) return;

    // Paso 3: Mostrar modal para ingresar metadatos (observación y tipo)
    final metadatos = await ImageMetadataSheet.show(
      context,
      imagenSeleccionada.path,
    );

    if (metadatos == null || !mounted) return;

    // Paso 4: Subir imagen con metadatos
    // Conserva el estatus actual de la solicitud (NO marca como Atendida)
    setState(() => _isUploading = true);

    final result = await _imageUploader.subirImagenConMetadatos(
      imagenPath: imagenSeleccionada.path,
      solicitudId: widget.solicitud.solicitudId,
      dependenciaId: widget.solicitud.dependenciaId,
      estatusId: widget.solicitud.ultimoEstatusId, // Conserva estatus actual
      servicioId: widget.solicitud.servicioId,
      observacion: metadatos.observacion,
      tipoFoto: metadatos.tipoFoto,
      soloImagen: true,
      onImageUploaded: (imagen) {
        setState(() {
          _imagenesLocales.add(imagen);
        });
      },
    );

    setState(() => _isUploading = false);

    // Mostrar diálogo del resultado
    if (result != null && mounted) {
      await ResultDialog.show(
        context,
        type: result.success ? ResultType.success : ResultType.error,
        message: result.message,
      );
    }
  }

  /// Marca la solicitud como atendida con imagen y metadatos
  /// Cambia el estatus a 17 (Atendida)
  Future<void> _marcarComoAtendida() async {
    // Paso 1: Seleccionar origen de la imagen
    final origen = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tomar Foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de Galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancelar'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );

    if (origen == null) return;

    // Paso 2: Capturar/seleccionar la imagen
    final picker = ImagePicker();
    final XFile? imagenSeleccionada = await picker.pickImage(
      source: origen,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (imagenSeleccionada == null || !mounted) return;

    // Paso 3: Mostrar modal para ingresar metadatos (observación y tipo)
    final metadatos = await ImageMetadataSheet.show(
      context,
      imagenSeleccionada.path,
    );

    if (metadatos == null || !mounted) return;

    // Paso 4: Subir imagen con metadatos y marcar como Atendida (17)
    setState(() => _isUploading = true);

    final result = await _imageUploader.subirImagenConMetadatos(
      imagenPath: imagenSeleccionada.path,
      solicitudId: widget.solicitud.solicitudId,
      dependenciaId: widget.solicitud.dependenciaId,
      estatusId: 17, // Marca como Atendida
      servicioId: widget.solicitud.servicioId,
      observacion: metadatos.observacion,
      tipoFoto: metadatos.tipoFoto,
      soloImagen: false, // Cambia el estatus
      onImageUploaded: (imagen) {
        setState(() {
          _imagenesLocales.add(imagen);
        });
      },
    );

    setState(() => _isUploading = false);

    // Mostrar diálogo del resultado
    if (result != null && mounted) {
      await ResultDialog.show(
        context,
        type: result.success ? ResultType.success : ResultType.error,
        message: result.message,
      );

      // Si fue exitoso, notificar para refrescar la lista
      if (result.success && widget.onImageUploaded != null) {
        widget.onImageUploaded!();
      }
    }
  }

  /// Muestra la imagen en pantalla completa
  void _mostrarImagenCompleta(int indice) {
    showDialog(
      context: context,
      builder: (context) => VisorImagenesCompleto(
        imagenes: _imagenesLocales,
        indiceInicial: indice,
      ),
    );
  }
}

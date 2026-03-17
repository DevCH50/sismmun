import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sismmun/src/domain/models/Solicitud.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeBloc.dart';
import 'package:sismmun/src/presentation/pages/home/widget/VisorImagenesCompleto.dart';
import 'package:sismmun/src/presentation/pages/home/widget/ImageUploaderHelper.dart';
import 'package:sismmun/src/presentation/pages/home/widget/ImageMetadataSheet.dart';
import 'package:sismmun/src/presentation/pages/home/widget/SolicitudGaleria.dart';
import 'package:sismmun/src/presentation/widgets/ResultDialog.dart';

/// Widget que representa una tarjeta de solicitud en la lista principal.
///
/// Muestra los datos de la solicitud ([Solicitud]) y permite:
/// - Agregar imágenes sin cambiar el estatus.
/// - Marcar la solicitud como Atendida (estatus 17) adjuntando una imagen.
///
/// La lógica de subida reside en [ImageUploaderHelper]; la galería de
/// miniaturas es delegada a [SolicitudGaleria].
class SolicitudItem extends StatefulWidget {
  /// Solicitud a mostrar.
  final Solicitud solicitud;

  /// Callback opcional invocado cuando se sube una imagen con éxito y
  /// se cambia el estatus (marcar como atendida).
  final VoidCallback? onImageUploaded;

  /// BLoC de la pantalla principal (requerido por el árbol de dependencias).
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

  /// Indica si hay una subida en proceso para deshabilitar controles.
  bool _isUploading = false;

  /// Copia local de las imágenes, se actualiza al subir nuevas fotos.
  List<Imagen?> _imagenesLocales = [];

  @override
  void initState() {
    super.initState();
    _imagenesLocales = List.from(widget.solicitud.imagenes ?? []);
  }

  // ---------------------------------------------------------------------------
  // Build principal
  // ---------------------------------------------------------------------------

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
            if (_imagenesLocales.isNotEmpty)
              SolicitudGaleria(
                imagenes: _imagenesLocales,
                isUploading: _isUploading,
                onAgregarImagen: () => _procesarImagen(marcarAtendida: false),
                onVerImagen: _mostrarImagenCompleta,
              ),
            if (_imagenesLocales.isEmpty) _buildBotonAgregarImagen(),
            _buildBotonMarcarAtendida(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sub-widgets de encabezado
  // ---------------------------------------------------------------------------

  /// Fila con fecha de ingreso (izquierda) e ID de solicitud (derecha).
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

  /// Título / descripción de la denuncia.
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

  /// Nombre del servicio asociado a la solicitud.
  Widget _buildServicio() {
    return Text(
      widget.solicitud.servicio,
      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
    );
  }

  /// Botón que aparece solo cuando la solicitud no tiene imágenes aún.
  Widget _buildBotonAgregarImagen() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextButton.icon(
        onPressed: _isUploading
            ? null
            : () => _procesarImagen(marcarAtendida: false),
        icon: const Icon(Icons.add_photo_alternate, size: 18),
        label: const Text('+ Imagen'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          foregroundColor: Colors.blue.shade700,
        ),
      ),
    );
  }

  /// Botón principal para marcar la solicitud como atendida.
  Widget _buildBotonMarcarAtendida() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _isUploading
              ? null
              : () => _procesarImagen(marcarAtendida: true),
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

  // ---------------------------------------------------------------------------
  // Lógica de imagen (métodos privados)
  // ---------------------------------------------------------------------------

  /// Flujo unificado para agregar imagen con o sin cambio de estatus.
  ///
  /// Si [marcarAtendida] es `true` se usa `estatusId = 17` y
  /// `soloImagen = false`; si es `false` se conserva el estatus actual.
  Future<void> _procesarImagen({required bool marcarAtendida}) async {
    // Paso 1: Elegir origen (cámara o galería)
    final origen = await _seleccionarOrigenImagen();
    if (origen == null) return;

    // Paso 2: Capturar / seleccionar la imagen
    final picker = ImagePicker();
    final XFile? imagenSeleccionada = await picker.pickImage(
      source: origen,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (imagenSeleccionada == null || !mounted) return;

    // Paso 3: Recopilar metadatos (observación y tipo de foto)
    final metadatos = await ImageMetadataSheet.show(
      context,
      imagenSeleccionada.path,
    );
    if (metadatos == null || !mounted) return;

    // Paso 4: Subir imagen
    setState(() => _isUploading = true);

    final result = await _imageUploader.subirImagenConMetadatos(
      imagenPath: imagenSeleccionada.path,
      solicitudId: widget.solicitud.solicitudId,
      dependenciaId: widget.solicitud.dependenciaId,
      estatusId: marcarAtendida ? 17 : widget.solicitud.ultimoEstatusId,
      servicioId: widget.solicitud.servicioId,
      observacion: metadatos.observacion,
      tipoFoto: metadatos.tipoFoto,
      soloImagen: !marcarAtendida,
      onImageUploaded: (imagen) {
        setState(() => _imagenesLocales.add(imagen));
      },
    );

    setState(() => _isUploading = false);

    // Paso 5: Mostrar resultado
    if (result != null && mounted) {
      await ResultDialog.show(
        context,
        type: result.success ? ResultType.success : ResultType.error,
        message: result.message,
      );

      // Notificar al padre solo cuando se marcó como atendida con éxito
      if (marcarAtendida && result.success && widget.onImageUploaded != null) {
        widget.onImageUploaded!();
      }
    }
  }

  /// Muestra un bottom sheet para que el usuario elija cámara o galería.
  ///
  /// Devuelve el [ImageSource] seleccionado, o `null` si cancela.
  Future<ImageSource?> _seleccionarOrigenImagen() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tomar Foto'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de Galería'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
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

  /// Abre el [VisorImagenesCompleto] en el índice indicado.
  void _mostrarImagenCompleta(int indice) {
    showDialog(
      context: context,
      builder: (_) => VisorImagenesCompleto(
        imagenes: _imagenesLocales,
        indiceInicial: indice,
      ),
    );
  }
}

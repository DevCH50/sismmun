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
import 'package:sismmun/src/domain/models/MultiUploadResult.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/presentation/pages/home/widget/MultiImageMetadataSheet.dart';

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

  /// Contador de imágenes tipo "Después" subidas exitosamente.
  /// El botón verde solo se habilita cuando este contador > 0.
  int _imagenesDespes = 0;

  /// Texto de progreso durante subida múltiple (ej: "Subiendo 2 de 5...").
  String? _textoProgreso;

  @override
  void initState() {
    super.initState();
    _imagenesLocales = List.from(widget.solicitud.imagenes ?? []);
    // Contar imágenes tipo "después" ya presentes al cargar la solicitud.
    _imagenesDespes = _imagenesLocales
        .where((img) {
          final tipo = img?.tipoFoto.trim().toLowerCase() ?? '';
          return tipo == 'despues' || tipo == 'después';
        })
        .length;
  }

  // ---------------------------------------------------------------------------
  // Build principal
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSolicitudId(cs),
            const SizedBox(height: 4),
            _buildTitulo(),
            const SizedBox(height: 4),
            _buildServicio(cs),
            if (_imagenesLocales.isNotEmpty)
              SolicitudGaleria(
                imagenes: _imagenesLocales,
                isUploading: _isUploading,
                onAgregarImagen: () => _procesarImagen(marcarAtendida: false),
                onVerImagen: _mostrarImagenCompleta,
              ),
            if (_imagenesLocales.isEmpty) _buildBotonAgregarImagen(cs),
            _buildBotonMarcarAtendida(cs),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sub-widgets de encabezado
  // ---------------------------------------------------------------------------

  /// Fila con fecha de ingreso (izquierda) e ID de solicitud (derecha).
  Widget _buildSolicitudId(ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.solicitud.fechaIngreso,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: cs.onSurfaceVariant,
          ),
        ),
        Text(
          widget.solicitud.solicitudId.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: cs.onSurfaceVariant,
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
  Widget _buildServicio(ColorScheme cs) {
    return Text(
      widget.solicitud.servicio,
      style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
    );
  }

  /// Botón que aparece solo cuando la solicitud no tiene imágenes aún.
  Widget _buildBotonAgregarImagen(ColorScheme cs) {
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
          foregroundColor: cs.primary,
        ),
      ),
    );
  }

  /// Botón principal para marcar la solicitud como atendida.
  ///
  /// Se habilita únicamente cuando hay al menos una imagen tipo "Después"
  /// subida en esta sesión, lo que garantiza evidencia fotográfica del trabajo.
  Widget _buildBotonMarcarAtendida(ColorScheme cs) {
    final puedeMarcar = !_isUploading && _imagenesDespes > 0;
    final textoBoton = _textoProgreso ??
        (_isUploading ? 'Subiendo imagen...' : 'Marcar como Atendida');

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_imagenesDespes == 0 && !_isUploading)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Sube al menos una foto "Después" para habilitar este botón',
                style: TextStyle(fontSize: 11, color: cs.tertiary),
                textAlign: TextAlign.center,
              ),
            ),
          ElevatedButton.icon(
            onPressed: puedeMarcar
                ? () => _procesarImagen(marcarAtendida: true)
                : null,
            icon: _isUploading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cs.onPrimary,
                    ),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(textoBoton),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              disabledBackgroundColor: cs.surfaceContainerHighest,
              disabledForegroundColor: cs.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Lógica de imagen (métodos privados)
  // ---------------------------------------------------------------------------

  /// Flujo unificado para agregar imagen(es) con o sin cambio de estatus.
  ///
  /// - Cámara: selecciona una foto → metadata sheet individual → sube.
  /// - Galería: selecciona múltiples fotos → metadata sheet compartida → sube todas.
  ///
  /// Si [marcarAtendida] es true se usa estatusId 17 y soloImagen=false.
  Future<void> _procesarImagen({required bool marcarAtendida}) async {
    final origen = await _seleccionarOrigenImagen();
    if (origen == null) return;

    if (origen == ImageSource.camera) {
      await _procesarImagenCamara(marcarAtendida: marcarAtendida);
    } else {
      await _procesarImagenesGaleria(marcarAtendida: marcarAtendida);
    }
  }

  /// Flujo para cámara: una foto con su propio metadata sheet.
  Future<void> _procesarImagenCamara({required bool marcarAtendida}) async {
    final picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (imagen == null || !mounted) return;

    final metadatos = await ImageMetadataSheet.show(context, imagen.path);
    if (metadatos == null || !mounted) return;

    setState(() {
      _isUploading = true;
      _textoProgreso = null;
    });

    final result = await _imageUploader.subirImagenConMetadatos(
      imagenPath: imagen.path,
      solicitudId: widget.solicitud.solicitudId,
      dependenciaId: widget.solicitud.dependenciaId,
      estatusId: marcarAtendida ? 17 : widget.solicitud.ultimoEstatusId,
      servicioId: widget.solicitud.servicioId,
      observaciones: metadatos.observaciones,
      tipoFoto: metadatos.tipoFoto,
      soloImagen: !marcarAtendida,
      onImageUploaded: (imagen) {
        setState(() {
          _imagenesLocales.add(imagen);
          if (metadatos.tipoFoto == TipoFoto.despues) _imagenesDespes++;
        });
      },
    );

    setState(() => _isUploading = false);

    if (result != null && mounted) {
      await ResultDialog.show(
        context,
        type: result.success ? ResultType.success : ResultType.error,
        message: result.message,
      );
      if (marcarAtendida && result.success) widget.onImageUploaded?.call();
    }
  }

  /// Flujo para galería: selección múltiple con metadata compartida.
  Future<void> _procesarImagenesGaleria({required bool marcarAtendida}) async {
    final picker = ImagePicker();
    final List<XFile> imagenes = await picker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (imagenes.isEmpty || !mounted) return;

    final paths = imagenes.map((x) => x.path).toList();

    // Si es solo una imagen, usar el sheet individual para mejor UX
    if (paths.length == 1) {
      final metadatos = await ImageMetadataSheet.show(context, paths.first);
      if (metadatos == null || !mounted) return;

      setState(() {
        _isUploading = true;
        _textoProgreso = null;
      });

      final result = await _imageUploader.subirImagenConMetadatos(
        imagenPath: paths.first,
        solicitudId: widget.solicitud.solicitudId,
        dependenciaId: widget.solicitud.dependenciaId,
        estatusId: marcarAtendida ? 17 : widget.solicitud.ultimoEstatusId,
        servicioId: widget.solicitud.servicioId,
        observaciones: metadatos.observaciones,
        tipoFoto: metadatos.tipoFoto,
        soloImagen: !marcarAtendida,
        onImageUploaded: (img) {
          setState(() {
            _imagenesLocales.add(img);
            if (metadatos.tipoFoto == TipoFoto.despues) _imagenesDespes++;
          });
        },
      );

      setState(() => _isUploading = false);

      if (result != null && mounted) {
        await ResultDialog.show(
          context,
          type: result.success ? ResultType.success : ResultType.error,
          message: result.message,
        );
        if (marcarAtendida && result.success) widget.onImageUploaded?.call();
      }
      return;
    }

    // Múltiples imágenes: usar MultiImageMetadataSheet
    final metadatos = await MultiImageMetadataSheet.show(context, paths);
    if (metadatos == null || !mounted) return;

    setState(() {
      _isUploading = true;
      _textoProgreso = 'Preparando...';
    });

    final MultiUploadResult multiResult =
        await _imageUploader.subirMultiplesImagenes(
      imagePaths: paths,
      solicitudId: widget.solicitud.solicitudId,
      dependenciaId: widget.solicitud.dependenciaId,
      estatusId: marcarAtendida ? 17 : widget.solicitud.ultimoEstatusId,
      servicioId: widget.solicitud.servicioId,
      observaciones: metadatos.observaciones,
      tipoFoto: metadatos.tipoFoto,
      soloImagen: !marcarAtendida,
      onProgreso: (actual, total) {
        if (mounted) {
          setState(() => _textoProgreso = 'Subiendo $actual de $total...');
        }
      },
      onImageUploaded: (img) {
        if (mounted) {
          setState(() {
            _imagenesLocales.add(img);
            if (metadatos.tipoFoto == TipoFoto.despues) _imagenesDespes++;
          });
        }
      },
    );

    setState(() {
      _isUploading = false;
      _textoProgreso = null;
    });

    if (!mounted) return;

    await ResultDialog.show(
      context,
      type: multiResult.todasExitosas ? ResultType.success : ResultType.error,
      message: multiResult.mensajeResumen,
    );

    if (marcarAtendida && multiResult.algunaExitosa) {
      widget.onImageUploaded?.call();
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

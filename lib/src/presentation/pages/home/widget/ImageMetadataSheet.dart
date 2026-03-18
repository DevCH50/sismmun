import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/presentation/widgets/ResultDialog.dart';

/// Resultado del modal de metadatos de imagen
class ImageMetadataResult {
  final String observaciones;
  final TipoFoto tipoFoto;

  ImageMetadataResult({
    required this.observaciones,
    required this.tipoFoto,
  });
}

/// Bottom sheet moderno para capturar metadatos de imagen
///
/// Solicita:
/// - Tipo de foto (Antes/Después) con SegmentedButton
/// - Observación con TextField
///
/// Diseño UX/UI moderno siguiendo Material Design 3
/// Responsivo para todos los tamaños de pantalla y versiones de Android/iOS
class ImageMetadataSheet extends StatefulWidget {
  final String imagePath;

  const ImageMetadataSheet({
    super.key,
    required this.imagePath,
  });

  /// Muestra el bottom sheet y retorna los metadatos o null si se cancela
  static Future<ImageMetadataResult?> show(
    BuildContext context,
    String imagePath,
  ) {
    return showModalBottomSheet<ImageMetadataResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ImageMetadataSheet(imagePath: imagePath),
    );
  }

  @override
  State<ImageMetadataSheet> createState() => _ImageMetadataSheetState();
}

class _ImageMetadataSheetState extends State<ImageMetadataSheet> {
  final TextEditingController _observacionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  TipoFoto _tipoFotoSeleccionado = TipoFoto.antes;

  @override
  void initState() {
    super.initState();
    // Scroll automático al enfocar el campo de texto
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _observacionController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Hace scroll hacia abajo cuando el campo de observación recibe foco
  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;
    final isKeyboardVisible = bottomInset > 0;

    // Calcular altura máxima del modal (90% de la pantalla)
    final maxHeight = screenHeight * 0.9;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle del bottom sheet (fijo arriba)
          _buildHandle(colorScheme),

          // Contenido scrolleable
          Flexible(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 8,
                bottom: bottomInset + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  _buildTitulo(theme),
                  const SizedBox(height: 16),

                  // Vista previa de la imagen (más pequeña si teclado visible)
                  _buildVistaPrevia(isKeyboardVisible, colorScheme),
                  const SizedBox(height: 16),

                  // Selector Antes/Después
                  _buildSelectorTipoFoto(colorScheme),
                  const SizedBox(height: 16),

                  // Campo de observación
                  _buildCampoObservacion(colorScheme),
                  const SizedBox(height: 20),

                  // Botones de acción
                  _buildBotonesAccion(colorScheme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle visual del bottom sheet
  Widget _buildHandle(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 4),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant.withAlpha(102),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  /// Título del modal
  Widget _buildTitulo(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Detalles de la imagen',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Vista previa de la imagen seleccionada
  /// Se reduce de tamaño cuando el teclado está visible
  Widget _buildVistaPrevia(bool isKeyboardVisible, ColorScheme cs) {
    final height = isKeyboardVisible ? 100.0 : 150.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.file(
        File(widget.imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported,
                    size: 40, color: cs.onSurfaceVariant),
                const SizedBox(height: 4),
                Text(
                  'Vista previa no disponible',
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Selector de tipo de foto con SegmentedButton (Material 3)
  Widget _buildSelectorTipoFoto(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Cuándo fue tomada esta foto?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<TipoFoto>(
            segments: const [
              ButtonSegment<TipoFoto>(
                value: TipoFoto.antes,
                label: Text('Antes'),
                icon: Icon(Icons.history, size: 18),
              ),
              ButtonSegment<TipoFoto>(
                value: TipoFoto.despues,
                label: Text('Después'),
                icon: Icon(Icons.check_circle_outline, size: 18),
              ),
            ],
            selected: {_tipoFotoSeleccionado},
            onSelectionChanged: (Set<TipoFoto> selection) {
              setState(() {
                _tipoFotoSeleccionado = selection.first;
              });
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Campo de texto para la observación
  Widget _buildCampoObservacion(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Observaciones *',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _observacionController,
          focusNode: _focusNode,
          minLines: 2,
          maxLines: 4,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _confirmar(),
          decoration: InputDecoration(
            hintText: 'Describe lo que muestra la imagen...',
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withAlpha(128),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: colorScheme.outline.withAlpha(77),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            counterStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  /// Botones de acción (Cancelar y Subir)
  Widget _buildBotonesAccion(ColorScheme colorScheme) {
    return SafeArea(
      top: false,
      child: Row(
        children: [
          // Botón Cancelar
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(width: 12),
          // Botón Subir
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              onPressed: _confirmar,
              icon: const Icon(Icons.cloud_upload_outlined, size: 18),
              label: const Text('Subir'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Confirma y retorna los metadatos
  void _confirmar() async {
    final observaciones = _observacionController.text.trim();

    // Validar que haya observación
    if (observaciones.isEmpty) {
      await ResultDialog.warning(
        context,
        message: 'Por favor, escribe una observación',
      );
      _focusNode.requestFocus();
      return;
    }

    Navigator.pop(
      context,
      ImageMetadataResult(
        observaciones: observaciones,
        tipoFoto: _tipoFotoSeleccionado,
      ),
    );
  }
}

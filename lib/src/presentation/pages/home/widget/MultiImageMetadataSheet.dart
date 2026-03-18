import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/presentation/widgets/ResultDialog.dart';

/// Resultado del modal de metadatos para múltiples imágenes.
class MultiImageMetadataResult {
  /// Observación compartida para todas las imágenes.
  final String observaciones;

  /// Tipo de foto compartido (Antes/Después).
  final TipoFoto tipoFoto;

  /// Rutas locales de las imágenes seleccionadas.
  final List<String> imagePaths;

  const MultiImageMetadataResult({
    required this.observaciones,
    required this.tipoFoto,
    required this.imagePaths,
  });
}

/// Bottom sheet para capturar metadatos de múltiples imágenes a la vez.
///
/// Muestra una fila de miniaturas de las imágenes seleccionadas,
/// un selector de tipo (Antes/Después) y un campo de observación
/// compartidos para todas las imágenes.
///
/// Diseño Material Design 3, compatible con tema claro/oscuro y
/// optimizado para Android e iOS.
class MultiImageMetadataSheet extends StatefulWidget {
  /// Rutas locales de las imágenes seleccionadas.
  final List<String> imagePaths;

  const MultiImageMetadataSheet({
    super.key,
    required this.imagePaths,
  });

  /// Muestra el bottom sheet y retorna los metadatos, o null si se cancela.
  static Future<MultiImageMetadataResult?> show(
    BuildContext context,
    List<String> imagePaths,
  ) {
    return showModalBottomSheet<MultiImageMetadataResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiImageMetadataSheet(imagePaths: imagePaths),
    );
  }

  @override
  State<MultiImageMetadataSheet> createState() =>
      _MultiImageMetadataSheetState();
}

class _MultiImageMetadataSheetState extends State<MultiImageMetadataSheet> {
  final TextEditingController _observacionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  TipoFoto _tipoFoto = TipoFoto.antes;

  @override
  void initState() {
    super.initState();
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

  /// Scroll automático al enfocar el campo de observación.
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(colorScheme),
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
                  _buildTitulo(theme),
                  const SizedBox(height: 12),
                  _buildThumbnails(colorScheme),
                  const SizedBox(height: 16),
                  _buildSelectorTipoFoto(colorScheme),
                  const SizedBox(height: 16),
                  _buildCampoObservacion(colorScheme),
                  const SizedBox(height: 20),
                  _buildBotones(colorScheme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle visual del bottom sheet.
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

  /// Título con contador de imágenes.
  Widget _buildTitulo(ThemeData theme) {
    final n = widget.imagePaths.length;
    return Row(
      children: [
        Icon(Icons.photo_library_outlined,
            color: theme.colorScheme.primary, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$n ${n == 1 ? 'imagen seleccionada' : 'imágenes seleccionadas'}',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  /// Fila horizontal de miniaturas con índice.
  Widget _buildThumbnails(ColorScheme colorScheme) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imagePaths.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => _buildThumbItem(colorScheme, i),
      ),
    );
  }

  /// Miniatura individual con número de posición.
  Widget _buildThumbItem(ColorScheme colorScheme, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(widget.imagePaths[index]),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 90,
              height: 90,
              color: colorScheme.surfaceContainerHighest,
              child: Icon(Icons.image_not_supported,
                  color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  /// Selector Antes/Después compartido para todas las imágenes.
  Widget _buildSelectorTipoFoto(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Cuándo fueron tomadas?',
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
            selected: {_tipoFoto},
            onSelectionChanged: (s) => setState(() => _tipoFoto = s.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Campo de observación compartido para todas las imágenes.
  Widget _buildCampoObservacion(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Observación *',
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
            hintText: 'Describe lo que muestran las imágenes...',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withAlpha(128),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: colorScheme.outline.withAlpha(77)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(12),
            counterStyle: TextStyle(
                color: colorScheme.onSurfaceVariant, fontSize: 11),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  /// Botones Cancelar y Subir.
  Widget _buildBotones(ColorScheme colorScheme) {
    final n = widget.imagePaths.length;
    return SafeArea(
      top: false,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              onPressed: _confirmar,
              icon: const Icon(Icons.cloud_upload_outlined, size: 18),
              label: Text('Subir $n ${n == 1 ? 'imagen' : 'imágenes'}'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Valida y retorna los metadatos al caller.
  void _confirmar() async {
    final observaciones = _observacionController.text.trim();
    if (observaciones.isEmpty) {
      await ResultDialog.warning(
        context,
        message: 'Por favor, escribe una observación',
      );
      _focusNode.requestFocus();
      return;
    }
    if (!mounted) return;
    Navigator.pop(
      context,
      MultiImageMetadataResult(
        observaciones: observaciones,
        tipoFoto: _tipoFoto,
        imagePaths: widget.imagePaths,
      ),
    );
  }
}

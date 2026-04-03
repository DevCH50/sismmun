import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ListTile que copia su valor al portapapeles al ser tocado.
///
/// Al tocar, copia el valor y muestra una palomita animada en el trailing
/// durante 1 segundo, sin toast ni diálogo — compatible con drawer abierto.
class CopyableListTile extends StatefulWidget {
  /// Ícono a mostrar a la izquierda.
  final IconData icon;

  /// Color del ícono leading. Por defecto usa [ColorScheme.primary].
  final Color? iconColor;

  /// Etiqueta descriptiva del campo (texto pequeño arriba).
  final String label;

  /// Valor a mostrar y copiar.
  final String value;

  const CopyableListTile({
    super.key,
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  State<CopyableListTile> createState() => _CopyableListTileState();
}

class _CopyableListTileState extends State<CopyableListTile> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.value));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      dense: true,
      leading: Icon(
        widget.icon,
        size: 22,
        color: widget.iconColor ?? cs.primary,
      ),
      title: Text(
        widget.label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 11,
          color: cs.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        widget.value,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: cs.onSurface,
        ),
      ),
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: _copied
            ? Icon(
                Icons.check_circle_rounded,
                key: const ValueKey('check'),
                size: 20,
                color: cs.primary,
              )
            : Icon(
                Icons.copy,
                key: const ValueKey('copy'),
                size: 18,
                color: cs.onSurfaceVariant.withValues(alpha: 0.5),
              ),
      ),
      onTap: _copyToClipboard,
    );
  }
}

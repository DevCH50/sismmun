import 'package:flutter/material.dart';

/// Tipo de resultado para el diálogo
enum ResultType {
  success,
  error,
  warning,
  info,
}

/// Extensión para obtener propiedades visuales del tipo de resultado
extension ResultTypeExtension on ResultType {
  IconData get icon {
    switch (this) {
      case ResultType.success:
        return Icons.check_circle_rounded;
      case ResultType.error:
        return Icons.error_rounded;
      case ResultType.warning:
        return Icons.warning_amber_rounded;
      case ResultType.info:
        return Icons.info_rounded;
    }
  }

  /// Color principal (ícono y fondo del botón) según el colorScheme del tema.
  Color resolveColor(ColorScheme cs) {
    switch (this) {
      case ResultType.success:
        return cs.tertiary;
      case ResultType.error:
        return cs.error;
      case ResultType.warning:
        return cs.primary;
      case ResultType.info:
        return cs.secondary;
    }
  }

  /// Color de relleno del círculo de fondo del ícono.
  Color resolveColorContainer(ColorScheme cs) {
    switch (this) {
      case ResultType.success:
        return cs.tertiaryContainer;
      case ResultType.error:
        return cs.errorContainer;
      case ResultType.warning:
        return cs.primaryContainer;
      case ResultType.info:
        return cs.secondaryContainer;
    }
  }

  /// Color del texto/ícono sobre el botón principal.
  Color resolveOnColor(ColorScheme cs) {
    switch (this) {
      case ResultType.success:
        return cs.onTertiary;
      case ResultType.error:
        return cs.onError;
      case ResultType.warning:
        return cs.onPrimary;
      case ResultType.info:
        return cs.onSecondary;
    }
  }

  String get defaultTitle {
    switch (this) {
      case ResultType.success:
        return 'Éxito';
      case ResultType.error:
        return 'Error';
      case ResultType.warning:
        return 'Advertencia';
      case ResultType.info:
        return 'Información';
    }
  }
}

/// Diálogo de resultado moderno con diseño Material Design 3
///
/// Uso:
/// ```dart
/// await ResultDialog.show(
///   context,
///   type: ResultType.success,
///   message: 'Imagen subida correctamente',
/// );
/// ```
class ResultDialog extends StatelessWidget {
  final ResultType type;
  final String? title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const ResultDialog({
    super.key,
    required this.type,
    this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  /// Muestra el diálogo y espera a que se cierre
  static Future<void> show(
    BuildContext context, {
    required ResultType type,
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
    bool barrierDismissible = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => ResultDialog(
        type: type,
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  /// Muestra diálogo de éxito
  static Future<void> success(
    BuildContext context, {
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return show(
      context,
      type: ResultType.success,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Muestra diálogo de error
  static Future<void> error(
    BuildContext context, {
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return show(
      context,
      type: ResultType.error,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Muestra diálogo de advertencia
  static Future<void> warning(
    BuildContext context, {
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return show(
      context,
      type: ResultType.warning,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Muestra diálogo de información
  static Future<void> info(
    BuildContext context, {
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return show(
      context,
      type: ResultType.info,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono con fondo circular
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: type.resolveColorContainer(colorScheme),
              shape: BoxShape.circle,
            ),
            child: Icon(
              type.icon,
              size: 48,
              color: type.resolveColor(colorScheme),
            ),
          ),
          const SizedBox(height: 20),

          // Título
          Text(
            title ?? type.defaultTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Mensaje (scrolleable si es muy largo)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            child: SingleChildScrollView(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Botón
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPressed?.call();
              },
              style: FilledButton.styleFrom(
                backgroundColor: type.resolveColor(colorScheme),
                foregroundColor: type.resolveOnColor(colorScheme),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText ?? 'Aceptar',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

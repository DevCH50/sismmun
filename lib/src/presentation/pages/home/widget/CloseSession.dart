import 'package:flutter/material.dart';

/// Widget reutilizable para diálogos de confirmación
class CloseSession extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final String confirmText;
  final String cancelText;
  final Color? confirmButtonColor;
  final Color? confirmTextColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CloseSession({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.confirmButtonColor,
    this.confirmTextColor,
    this.onConfirm,
    this.onCancel,
  });

  /// Método estático para mostrar el diálogo y obtener resultado
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmButtonColor,
    Color? confirmTextColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => CloseSession(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmButtonColor: confirmButtonColor,
        confirmTextColor: confirmTextColor,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? Theme.of(context).primaryColor),
            const SizedBox(width: 12),
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.pop(context, false);
          },
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.pop(context, true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor ?? Theme.of(context).primaryColor,
          ),
          child: Text(
            confirmText,
            style: TextStyle(
              color: confirmTextColor ?? Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================
// EJEMPLO DE USO
// ============================================

// class ExampleUsage {
//   // Método 1: Usando el método estático (más simple)
//   void handleLogoutSimple(BuildContext context) async {
//     final shouldLogout = await ConfirmationDialog.show(
//       context: context,
//       title: 'Cerrar Sesión',
//       message: '¿Estás seguro que deseas cerrar sesión?',
//       icon: Icons.logout,
//       iconColor: Colors.orange,
//       confirmText: 'Cerrar Sesión',
//       cancelText: 'Cancelar',
//       confirmButtonColor: Colors.red,
//       confirmTextColor: Colors.white,
//     );

//     if (shouldLogout && context.mounted) {
//       // Tu lógica aquí
//       // bloc?.add(HomeLogoutEvent());
//       // Navigator.pushAndRemoveUntil(...);
//     }
//   }

//   // Método 2: Usando showDialog directamente (más control)
//   void handleLogoutAdvanced(BuildContext context) async {
//     final shouldLogout = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false, // Control adicional
//       builder: (context) => ConfirmationDialog(
//         title: 'Cerrar Sesión',
//         message: '¿Estás seguro que deseas cerrar sesión?',
//         icon: Icons.logout,
//         iconColor: Colors.orange,
//         confirmText: 'Cerrar Sesión',
//         cancelText: 'Cancelar',
//         confirmButtonColor: Colors.red,
//         confirmTextColor: Colors.white,
//         onConfirm: () {
//           // Lógica adicional antes de cerrar el diálogo
//           print('Usuario confirmó logout');
//         },
//         onCancel: () {
//           print('Usuario canceló logout');
//         },
//       ),
//     );

//     if (shouldLogout == true && context.mounted) {
//       // Tu lógica de logout
//     }
//   }

//   // Otros ejemplos de uso
//   void handleDeleteItem(BuildContext context) async {
//     final shouldDelete = await ConfirmationDialog.show(
//       context: context,
//       title: 'Eliminar Item',
//       message: '¿Estás seguro que deseas eliminar este elemento?',
//       icon: Icons.delete,
//       iconColor: Colors.red,
//       confirmText: 'Eliminar',
//       confirmButtonColor: Colors.red,
//     );

//     if (shouldDelete) {
//       // Eliminar item
//     }
//   }

//   void handleSaveChanges(BuildContext context) async {
//     final shouldSave = await ConfirmationDialog.show(
//       context: context,
//       title: 'Guardar Cambios',
//       message: 'Tienes cambios sin guardar. ¿Deseas guardarlos?',
//       icon: Icons.save,
//       iconColor: Colors.green,
//       confirmText: 'Guardar',
//       cancelText: 'Descartar',
//       confirmButtonColor: Colors.green,
//     );

//     if (shouldSave) {
//       // Guardar cambios
//     }
//   }
// }
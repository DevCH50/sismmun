import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? urlPhoto;
  final String nombre;
  final bool esBaja;
  final double radius;
  final bool showBorder; // ✅ Nuevo parámetro
  final bool showOnlineIndicator;
  final bool isOnline;

  const UserAvatar({
    super.key,
    this.urlPhoto,
    required this.nombre,
    this.esBaja = false,
    this.radius = 24,
    this.showBorder = false, // ✅ Nuevo parámetro
    this.showOnlineIndicator = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = esBaja ? Colors.red.shade100 : Colors.blue.shade100;
    final textColor = esBaja ? Colors.red.shade900 : Colors.blue.shade900;

    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor,
          child: _buildAvatarContent(textColor),
        ),
        if (showOnlineIndicator)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.4,
              height: radius * 0.4,
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarContent(Color textColor) {
    // Si no hay URL o está vacía, mostrar inicial
    if (urlPhoto == null || urlPhoto!.isEmpty) {
      return _buildInitial(textColor);
    }

    // Cargar imagen con caché
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: urlPhoto!,
        fit: BoxFit.cover,
        // Mientras carga
        placeholder: (context, url) => Center(
          child: SizedBox(
            width: radius,
            height: radius,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
        ),
        // Si hay error
        errorWidget: (context, url, error) {
          return _buildInitial(textColor);
        },
      ),
    );
  }

  Widget _buildInitial(Color textColor) {
    return Text(
      nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: radius * 0.8,
      ),
    );
  }
}

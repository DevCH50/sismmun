/// Tipo de foto: Antes o Después del trabajo
enum TipoFoto {
  antes,
  despues,
}

/// Extensión para obtener el valor string del tipo de foto
extension TipoFotoExtension on TipoFoto {
  String get valor {
    switch (this) {
      case TipoFoto.antes:
        return 'antes';
      case TipoFoto.despues:
        return 'despues';
    }
  }

  String get etiqueta {
    switch (this) {
      case TipoFoto.antes:
        return 'Antes';
      case TipoFoto.despues:
        return 'Después';
    }
  }
}

/// Modelo para la petición de subir imagen
class SubirImagenRequest {
  final int solicitudId;
  final int dependenciaId;
  final int estatusId;
  final int servicioId;
  final String imagenPath;
  final double? latitud;
  final double? longitud;
  final bool soloImagen;
  final String? observaciones; // Observación de la imagen
  final TipoFoto? tipoFoto; // Antes o Después
  final int userId;

  SubirImagenRequest({
    required this.solicitudId,
    required this.dependenciaId,
    required this.estatusId,
    required this.servicioId,
    required this.imagenPath,
    this.latitud,
    this.longitud,
    this.soloImagen = false,
    this.observaciones,
    this.tipoFoto,
    required this.userId,
  });

  Map<String, String> toMap() {
    return {
      'solicitud_id': solicitudId.toString(),
      'dependencia_id': dependenciaId.toString(),
      'estatus_id': estatusId.toString(),
      'servicio_id': servicioId.toString(),
      'imagen_path': imagenPath,
      'latitud': latitud?.toString() ?? '',
      'longitud': longitud?.toString() ?? '',
      'solo_imagen': soloImagen ? '1' : '0',
      'observaciones': observaciones ?? '',
      'tipo_foto': tipoFoto?.valor ?? '',
      'user_id': userId.toString(),
    };
  }
}

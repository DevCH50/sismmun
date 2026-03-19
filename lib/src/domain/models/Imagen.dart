class Imagen {
    /// ID de la imagen en el servidor (nullable: las imágenes recién subidas
    /// pueden no tenerlo hasta que se recargue la solicitud).
    int? id;
    String fecha;
    String urlImagen;
    String urlThumb;
    String observaciones;
    String tipoFoto;
    int status;
    String msg;
    bool isEliminable;

    Imagen({
        this.id,
        required this.fecha,
        required this.urlImagen,
        required this.urlThumb,
        this.observaciones = '',
        this.tipoFoto = '',
        this.status = 0,
        this.msg = '',
        this.isEliminable = false,
    });

    factory Imagen.fromJson(Map<String, dynamic> json) => Imagen(
        id: json['imagen_id'] ?? json['id'],
        fecha: json['fecha'] ?? '',
        urlImagen: json['url_imagen'] ?? '',
        urlThumb: json['url_thumb'] ?? '',
        observaciones: json['observaciones'] ?? '',
        tipoFoto: json['tipo_foto'] ?? '',
        status: json['status'] ?? 0,
        msg: json['msg'] ?? '',
        isEliminable: json['es_eliminable'] ?? false,
    );

    Map<String, dynamic> toJson() => {
        'imagen_id': id,
        'fecha': fecha,
        'url_imagen': urlImagen,
        'url_thumb': urlThumb,
        'observaciones': observaciones,
        'tipo_foto': tipoFoto,
        'status': status,
        'msg': msg,
        'es_eliminable': isEliminable,
    };
}
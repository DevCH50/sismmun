class Imagen {
    String fecha;
    String urlImagen;
    String urlThumb;
    String observaciones;
    String tipoFoto;
    int status;
    String msg;

    Imagen({
        required this.fecha,
        required this.urlImagen,
        required this.urlThumb,
        this.observaciones = '',
        this.tipoFoto = '',
        this.status = 0,
        this.msg = '',
    });

    factory Imagen.fromJson(Map<String, dynamic> json) => Imagen(
        fecha: json['fecha'] ?? '',
        urlImagen: json['url_imagen'] ?? '',
        urlThumb: json['url_thumb'] ?? '',
        observaciones: json['observaciones'] ?? '',
        tipoFoto: json['tipo_foto'] ?? '',
        status: json['status'] ?? 0,
        msg: json['msg'] ?? '',
    );

    Map<String, dynamic> toJson() => {
        'fecha': fecha,
        'url_imagen': urlImagen,
        'url_thumb': urlThumb,
        'observaciones': observaciones,
        'tipo_foto': tipoFoto,
        'status': status,
        'msg': msg,
    };
}
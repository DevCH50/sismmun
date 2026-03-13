class Imagen {
    String fecha;
    String urlImagen;
    String urlThumb;
    int status;
    String msg;

    Imagen({
        required this.fecha,
        required this.urlImagen,
        required this.urlThumb,
        this.status = 0,
        this.msg = '',
    });

    factory Imagen.fromJson(Map<String, dynamic> json) => Imagen(
        fecha: json['fecha'] ?? '',
        urlImagen: json['url_imagen'] ?? '',
        urlThumb: json['url_thumb'] ?? '',
        status: json['status'] ?? 0,
        msg: json['msg'] ?? '',
    );

    Map<String, dynamic> toJson() => {
        'fecha': fecha,
        'url_imagen': urlImagen,
        'url_thumb': urlThumb,
        'status': status,
        'msg': msg,
    };
}
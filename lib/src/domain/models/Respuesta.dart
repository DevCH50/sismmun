class Respuesta {
    int id;
    int denunciaId;
    int dependenciaId;
    int servicioId;
    int estatuId;
    DateTime fechaMovimiento;
    String observaciones;
    bool favorable;
    bool fueLeida;
    int creadoporId;

    Respuesta({
        required this.id,
        required this.denunciaId,
        required this.dependenciaId,
        required this.servicioId,
        required this.estatuId,
        required this.fechaMovimiento,
        required this.observaciones,
        required this.favorable,
        required this.fueLeida,
        required this.creadoporId,
    });

    factory Respuesta.fromJson(Map<String, dynamic> json) => Respuesta(
        id: json['id'],
        denunciaId: json['denuncia_id'],
        dependenciaId: json['dependencia_id'],
        servicioId: json['servicio_id'],
        estatuId: json['estatu_id'],
        fechaMovimiento: DateTime.parse(json['fecha_movimiento']),
        observaciones: json['observaciones'],
        favorable: json['favorable'],
        fueLeida: json['fue_leida'],
        creadoporId: json['creadopor_id'],
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'denuncia_id': denunciaId,
        'dependencia_id': dependenciaId,
        'servicio_id': servicioId,
        'estatu_id': estatuId,
        'fecha_movimiento': fechaMovimiento.toIso8601String(),
        'observaciones': observaciones,
        'favorable': favorable,
        'fue_leida': fueLeida,
        'creadopor_id': creadoporId,
    };
}

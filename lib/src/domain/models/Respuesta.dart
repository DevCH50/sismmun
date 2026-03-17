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
        id: json['id'] ?? 0,
        denunciaId: json['denuncia_id'] ?? 0,
        dependenciaId: json['dependencia_id'] ?? 0,
        servicioId: json['servicio_id'] ?? 0,
        estatuId: json['estatu_id'] ?? 0,
        fechaMovimiento: json['fecha_movimiento'] != null
            ? DateTime.parse(json['fecha_movimiento'])
            : DateTime.now(),
        observaciones: json['observaciones'] ?? '',
        favorable: json['favorable'] ?? false,
        fueLeida: json['fue_leida'] ?? false,
        creadoporId: json['creadopor_id'] ?? 0,
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

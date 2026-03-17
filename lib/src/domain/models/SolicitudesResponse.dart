import 'dart:convert';

import 'package:sismmun/src/domain/models/Solicitud.dart';

SolicitudesResponse solicitudesResponseFromJson(String str) => SolicitudesResponse.fromJson(json.decode(str));

String solicitudesResponseToJson(SolicitudesResponse data) => json.encode(data.toJson());

class SolicitudesResponse {
    int status;
    String msg;
    List<Solicitud> solicitudes;

    SolicitudesResponse({
        required this.status,
        required this.msg,
        required this.solicitudes,
    });

    factory SolicitudesResponse.fromJson(Map<String, dynamic> json) => SolicitudesResponse(
        status: json['status'] ?? 0,
        msg: json['msg'] ?? '',
        solicitudes: json['solicitudes'] != null
            ? List<Solicitud>.from(json['solicitudes'].map((x) => Solicitud.fromJson(x)))
            : [],
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'msg': msg,
        'solicitudes': List<Solicitud>.from(solicitudes.map((x) => x.toJson())),
    };
}

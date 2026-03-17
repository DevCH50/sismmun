import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/Respuesta.dart';

class Solicitud {
    int solicitudId;
    String fechaIngreso;
    String fechaUltimoEstatus;
    String denuncia;
    int dependenciaId;
    String dependencia;
    int servicioId;
    String servicio;
    int servicioUltimoEstatusId;
    String servicioUltimoEstatus;
    int ultimoEstatusId;
    String ultimoEstatus;
    int origenId;
    String origen;
    String latitud;
    String longitud;
    String observaciones;
    List<Imagen?>? imagenes;
    List<Respuesta?>? respuestas;
    

    Solicitud({
        required this.solicitudId,
        required this.fechaIngreso,
        required this.fechaUltimoEstatus,
        required this.denuncia,
        required this.dependenciaId,
        required this.dependencia,
        required this.servicioId,
        required this.servicio,
        required this.servicioUltimoEstatusId,
        required this.servicioUltimoEstatus,
        required this.ultimoEstatusId,
        required this.ultimoEstatus,
        required this.origenId,
        required this.origen,
        required this.latitud,
        required this.longitud,
        required this.observaciones,
        required this.imagenes,
        required this.respuestas,
    });

    factory Solicitud.fromJson(Map<String, dynamic> json) => Solicitud(
        solicitudId: json['solicitud_id'] ?? 0,
        fechaIngreso: json['fecha_ingreso'] ?? '',
        fechaUltimoEstatus: json['fecha_ultimo_estatus'] ?? '',
        denuncia: json['denuncia'] ?? '',
        dependenciaId: json['dependencia_id'] ?? 0,
        dependencia: json['dependencia'] ?? '',
        servicioId: json['servicio_id'] ?? 0,
        servicio: json['servicio'] ?? '',
        servicioUltimoEstatusId: json['servicio_ultimo_estatus_id'] ?? 0,
        servicioUltimoEstatus: json['servicio_ultimo_estatus'] ?? '',
        ultimoEstatusId: json['ultimo_estatus_id'] ?? 0,
        ultimoEstatus: json['ultimo_estatus'] ?? '',
        origenId: json['origen_id'] ?? 0,
        origen: json['origen'] ?? '',
        latitud: json['latitud'] ?? '',
        longitud: json['longitud'] ?? '',
        observaciones: json['observaciones'] ?? '',
        imagenes: json['imagenes'] != null
            ? List<Imagen>.from(json['imagenes'].map((x) => Imagen.fromJson(x)))
            : [],
        respuestas: json['respuestas'] != null
            ? List<Respuesta>.from(json['respuestas'].map((x) => Respuesta.fromJson(x)))
            : [],
    );

    Map<String, dynamic> toJson() => {
        'solicitud_id': solicitudId,
        'fecha_ingreso': fechaIngreso,
        'fecha_ultimo_estatus': fechaUltimoEstatus,
        'denuncia': denuncia,
        'dependencia_id': dependenciaId,
        'dependencia': dependencia,
        'servicio_id': servicioId,
        'servicio': servicio,
        'servicio_ultimo_estatus_id': servicioUltimoEstatusId,
        'servicio_ultimo_estatus': servicioUltimoEstatus,
        'ultimo_estatus_id': ultimoEstatusId,
        'ultimo_estatus': ultimoEstatus,
        'origen_id': origenId,
        'origen': origen,
        'latitud': latitud,
        'longitud': longitud,
        'observaciones': observaciones,
        'imagenes': imagenes != null ? List<dynamic>.from(imagenes!.map((x) => x?.toJson())) : [],
        'respuestas': respuestas != null ? List<dynamic>.from(respuestas!.map((x) => x?.toJson())) : [],
    };
}

// enum Dependencia {
//     ALUMBRADO_SM,
//     OBRAS_SM
// }

// final dependenciaValues = EnumValues({
//     'ALUMBRADO SM': Dependencia.ALUMBRADO_SM,
//     'OBRAS SM': Dependencia.OBRAS_SM
// });

// enum Origen {
//     ATENCIN_DIRECTA,
//     ATENCIN_DIRECTA_SAS,
//     COORDINACIN_DE_DELEGADOS,
//     PRENSA,
//     TELEFONO,
//     TELEFONO_072,
//     TELEFONO_SAS,
//     TELEREPORTAJE,
//     VENTANILLA_CMSM
// }


// final origenValues = EnumValues({
//     'ATENCIÓN DIRECTA': Origen.ATENCIN_DIRECTA,
//     'ATENCIÓN DIRECTA SAS': Origen.ATENCIN_DIRECTA_SAS,
//     'COORDINACIÓN DE DELEGADOS': Origen.COORDINACIN_DE_DELEGADOS,
//     'PRENSA': Origen.PRENSA,
//     'TELEFONO': Origen.TELEFONO,
//     'TELEFONO 072': Origen.TELEFONO_072,
//     'TELEFONO SAS': Origen.TELEFONO_SAS,
//     'TELEREPORTAJE': Origen.TELEREPORTAJE,
//     'VENTANILLA CMSM': Origen.VENTANILLA_CMSM
// });

// enum Servicio {
//     BACHEO,
//     REPARACIN_DE_LUMINARIAS,
//     RESANE_CON_ASFALTO
// }

// final servicioValues = EnumValues({
//     'BACHEO': Servicio.BACHEO,
//     'REPARACIÓN DE LUMINARIAS': Servicio.REPARACIN_DE_LUMINARIAS,
//     'RESANE CON ASFALTO': Servicio.RESANE_CON_ASFALTO
// });

// enum UltimoEstatus {
//     EN_PROCESO_PROGRAMADA
// }

// final ultimoEstatusValues = EnumValues({
//     'EN PROCESO / PROGRAMADA': UltimoEstatus.EN_PROCESO_PROGRAMADA
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//             reverseMap = map.map((k, v) => MapEntry(v, k));
//             return reverseMap;
//     }
// }
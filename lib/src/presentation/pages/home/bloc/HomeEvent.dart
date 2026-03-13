import 'package:equatable/equatable.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetHomesList extends HomeEvent {
  const GetHomesList();
}

class RefreshHomesList extends HomeEvent {
  const RefreshHomesList();
}

class HomeLogoutEvent extends HomeEvent {
  const HomeLogoutEvent();
}

class SubirImagenEvent extends HomeEvent {
  final SubirImagenRequest request;
  const SubirImagenEvent(this.request);
  @override
  List<Object?> get props => [request];
}

/// Evento para buscar/filtrar solicitudes
/// Busca por: solicitud_id, servicio_id, dependencia_id, estatus_id
/// También busca en: denuncia, servicio, dependencia, estatus (texto)
class SearchSolicitudesEvent extends HomeEvent {
  final String query;
  const SearchSolicitudesEvent(this.query);
  @override
  List<Object?> get props => [query];
}

/// Evento para limpiar la búsqueda y mostrar todas las solicitudes
class ClearSearchEvent extends HomeEvent {
  const ClearSearchEvent();
}

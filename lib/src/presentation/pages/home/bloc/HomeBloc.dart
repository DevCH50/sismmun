import 'package:sismmun/src/domain/models/SolicitudesResponse.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/HomeUseCases.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/SolicitudUseCases.dart';
import 'package:sismmun/src/domain/utils/Resource.dart' as utils;

import 'package:sismmun/src/presentation/pages/home/bloc/HomeEvent.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeUseCases homeUseCases;
  AuthUseCases authUseCases;
  SolicitudUseCases solicitudUseCases;

  HomeBloc(this.homeUseCases, this.authUseCases, this.solicitudUseCases) : super(HomeState.initial()) {
    on<GetHomesList>(_onGetHomesList);
    on<RefreshHomesList>(_onGetHomesList);
    on<HomeLogoutEvent>(_onLogout);
    on<SubirImagenEvent>(_onSubirImagen);
    on<SearchSolicitudesEvent>(_onSearchSolicitudes);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onLogout(HomeLogoutEvent event, Emitter<HomeState> emit) async {
    await authUseCases.logout.run();
  }

  Future<void> _onGetHomesList(HomeEvent event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final utils.Resource<dynamic> result = await homeUseCases.getSolicitudes.run();

      if (result is utils.Success) {
        final data = result.data;
        if (data is SolicitudesResponse) {
          emit(
            state.copyWith(
              solicitudes: data.solicitudes,
              solicitudesFiltradas: data.solicitudes, // Inicializar con todas
              solicitudesResponse: data,
              isLoading: false,
              errorMessage: null,
              isAtendida: false,
              isEnProceso: false,
              isRecibida: false,
              isCerrada: false,
              isCerradaRechazo: false,
              searchQuery: '', // Limpiar búsqueda al refrescar
              isSearching: false,
            ),
          );
        } else {
          emit(
            state.copyWith(isLoading: false, errorMessage: 'Datos inesperados'),
          );
        }
      } else if (result is utils.Error) {
        emit(state.copyWith(isLoading: false, errorMessage: result.msg));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Error inesperado: $e'),
      );
    }
  }

  Future<void> _onSubirImagen(
    SubirImagenEvent event,
    Emitter<HomeState> emit,
  ) async {
    final request = event.request;

    emit(state.copyWith(isUploadingImage: true));

    final utils.Resource<dynamic> result = await solicitudUseCases.subirImagen.run(request);

    if (result is utils.Success) {
      final imagen = result.data;
      final bool success = imagen.status == 1;
      final String emoji = success ? '✅' : '❌';
      final String mensaje = '$emoji ${imagen.msg}';
      emit(state.copyWith(
        isUploadingImage: false,
        uploadResultMessage: mensaje,
        uploadSuccess: success,
      ));
    } else if (result is utils.Error) {
      emit(state.copyWith(
        isUploadingImage: false,
        uploadResultMessage: '❌ ${result.msg}',
        uploadSuccess: false,
      ));
    }
  }

  /// Filtra las solicitudes según el texto de búsqueda
  /// Busca por: solicitud_id, servicio_id, dependencia_id, estatus_id
  /// También busca en campos de texto: denuncia, servicio, dependencia, estatus
  void _onSearchSolicitudes(
    SearchSolicitudesEvent event,
    Emitter<HomeState> emit,
  ) {
    final query = event.query.trim().toLowerCase();

    // Si la búsqueda está vacía, mostrar todas las solicitudes
    if (query.isEmpty) {
      emit(state.copyWith(
        solicitudesFiltradas: state.solicitudes,
        searchQuery: '',
        isSearching: false,
      ));
      return;
    }

    // Filtrar solicitudes
    final solicitudesFiltradas = state.solicitudes?.where((solicitud) {
      // Búsqueda por IDs (numéricos)
      final matchSolicitudId = solicitud.solicitudId.toString().contains(query);
      final matchServicioId = solicitud.servicioId.toString().contains(query);
      final matchDependenciaId = solicitud.dependenciaId.toString().contains(query);
      final matchEstatusId = solicitud.ultimoEstatusId.toString().contains(query);

      // Búsqueda por texto
      final matchDenuncia = solicitud.denuncia.toLowerCase().contains(query);
      final matchServicio = solicitud.servicio.toLowerCase().contains(query);
      final matchDependencia = solicitud.dependencia.toLowerCase().contains(query);
      final matchEstatus = solicitud.ultimoEstatus.toLowerCase().contains(query);
      final matchObservaciones = solicitud.observaciones.toLowerCase().contains(query);

      return matchSolicitudId ||
             matchServicioId ||
             matchDependenciaId ||
             matchEstatusId ||
             matchDenuncia ||
             matchServicio ||
             matchDependencia ||
             matchEstatus ||
             matchObservaciones;
    }).toList();

    emit(state.copyWith(
      solicitudesFiltradas: solicitudesFiltradas,
      searchQuery: query,
      isSearching: true,
    ));
  }

  /// Limpia la búsqueda y muestra todas las solicitudes
  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      solicitudesFiltradas: state.solicitudes,
      searchQuery: '',
      isSearching: false,
    ));
  }

}

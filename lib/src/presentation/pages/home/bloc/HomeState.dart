import 'package:equatable/equatable.dart';
import 'package:sismmun/src/domain/models/Solicitud.dart';
import 'package:sismmun/src/domain/models/SolicitudesResponse.dart';

class HomeState extends Equatable {
  final List<Solicitud>? solicitudes;
  final List<Solicitud>? solicitudesFiltradas; // Lista filtrada para mostrar
  final SolicitudesResponse? solicitudesResponse;
  final bool isLoading;
  final bool isUploadingImage;
  final String? errorMessage;
  final String? uploadResultMessage;
  final bool uploadSuccess;
  final bool isAtendida;
  final bool isEnProceso;
  final bool isRecibida;
  final bool isCerrada;
  final bool isCerradaRechazo;
  final int solicitudId;
  final String imagenPath;
  final int estatusId;
  final String searchQuery; // Texto de búsqueda actual
  final bool isSearching; // Indica si hay búsqueda activa

  const HomeState({
    this.solicitudes,
    this.solicitudesFiltradas,
    this.solicitudesResponse,
    this.isLoading = false,
    this.isUploadingImage = false,
    this.errorMessage,
    this.uploadResultMessage,
    this.uploadSuccess = false,
    this.isAtendida = false,
    this.isEnProceso = false,
    this.isRecibida = false,
    this.isCerrada = false,
    this.isCerradaRechazo = false,
    this.solicitudId = 0,
    this.imagenPath = '',
    this.estatusId = 17,
    this.searchQuery = '',
    this.isSearching = false,
  });

  factory HomeState.initial() => const HomeState();

  HomeState copyWith({
    List<Solicitud>? solicitudes,
    List<Solicitud>? solicitudesFiltradas,
    SolicitudesResponse? solicitudesResponse,
    bool? isLoading,
    bool? isUploadingImage,
    String? errorMessage,
    String? uploadResultMessage,
    bool? uploadSuccess,
    bool? isAtendida,
    bool? isEnProceso,
    bool? isRecibida,
    bool? isCerrada,
    bool? isCerradaRechazo,
    int? solicitudId,
    String? imagenPath,
    int? estatusId,
    String? searchQuery,
    bool? isSearching,
  }) {
    return HomeState(
      solicitudes: solicitudes ?? this.solicitudes,
      solicitudesFiltradas: solicitudesFiltradas ?? this.solicitudesFiltradas,
      solicitudesResponse: solicitudesResponse ?? this.solicitudesResponse,
      isLoading: isLoading ?? this.isLoading,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      errorMessage: errorMessage,
      uploadResultMessage: uploadResultMessage,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
      isAtendida: isAtendida ?? this.isAtendida,
      isEnProceso: isEnProceso ?? this.isEnProceso,
      isRecibida: isRecibida ?? this.isRecibida,
      isCerrada: isCerrada ?? this.isCerrada,
      isCerradaRechazo: isCerradaRechazo ?? this.isCerradaRechazo,
      solicitudId: solicitudId ?? this.solicitudId,
      imagenPath: imagenPath ?? this.imagenPath,
      estatusId: estatusId ?? this.estatusId,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
    solicitudes,
    solicitudesFiltradas,
    solicitudesResponse,
    isLoading,
    isUploadingImage,
    errorMessage,
    uploadResultMessage,
    uploadSuccess,
    isAtendida,
    isEnProceso,
    isRecibida,
    isCerrada,
    isCerradaRechazo,
    solicitudId,
    imagenPath,
    estatusId,
    searchQuery,
    isSearching,
  ];
}

import 'package:sismmun/src/presentation/pages/home/bloc/HomeBloc.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeEvent.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeState.dart';
import 'package:sismmun/src/presentation/pages/home/widget/SolicitudItem.dart';
import 'package:sismmun/src/presentation/pages/home/widget/SearchSolicitudes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget que muestra la lista de solicitudes con buscador y pull-to-refresh.
/// También maneja el estado de búsqueda sin resultados.
///
/// Parámetros:
/// - [state]: Estado actual del [HomeBloc].
/// - [bloc]: Referencia al [HomeBloc] activo para disparar eventos.
class HomeListaWidget extends StatelessWidget {
  /// Estado actual del bloc con la lista de solicitudes.
  final HomeState state;

  /// Referencia al bloc para disparar eventos desde los items.
  final HomeBloc bloc;

  const HomeListaWidget({
    super.key,
    required this.state,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final solicitudesAMostrar = state.solicitudesFiltradas ?? state.solicitudes!;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const RefreshHomesList());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: Column(
        children: [
          const SearchSolicitudes(),

          // Indicador de resultados cuando hay búsqueda activa
          if (state.isSearching)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 16, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text(
                    '${solicitudesAMostrar.length} resultado${solicitudesAMostrar.length != 1 ? 's' : ''}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

          // Lista o aviso de sin resultados
          if (state.solicitudesResponse != null)
            Expanded(
              child: solicitudesAMostrar.isEmpty
                  ? _buildSinResultados()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: solicitudesAMostrar.length,
                      itemBuilder: (context, index) {
                        final solicitud = solicitudesAMostrar[index];
                        return SolicitudItem(
                          solicitud: solicitud,
                          onImageUploaded: () => context
                              .read<HomeBloc>()
                              .add(const RefreshHomesList()),
                          bloc: bloc,
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }

  /// Mensaje cuando la búsqueda activa no arroja resultados.
  Widget _buildSinResultados() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.white70),
          SizedBox(height: 16),
          Text(
            'No se encontraron solicitudes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Intenta con otro término de búsqueda',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

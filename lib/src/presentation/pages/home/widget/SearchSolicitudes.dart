import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeBloc.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeEvent.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeState.dart';

/// Widget de búsqueda para filtrar solicitudes
///
/// Permite buscar por:
/// - solicitud_id (ID de la solicitud/denuncia)
/// - servicio_id (ID del servicio)
/// - dependencia_id (ID de la dependencia)
/// - estatus_id (ID del estatus)
/// - Texto en: denuncia, servicio, dependencia, estatus, observaciones
class SearchSolicitudes extends StatefulWidget {
  const SearchSolicitudes({super.key});

  @override
  State<SearchSolicitudes> createState() => _SearchSolicitudesState();
}

class _SearchSolicitudesState extends State<SearchSolicitudes> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.isSearching != current.isSearching ||
          previous.searchQuery != current.searchQuery,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Buscar por ID, servicio, dependencia...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: state.isSearching
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: _limpiarBusqueda,
                    )
                  : null,
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _focusNode.unfocus(),
          ),
        );
      },
    );
  }

  /// Maneja el cambio en el texto de búsqueda
  void _onSearchChanged(String query) {
    context.read<HomeBloc>().add(SearchSolicitudesEvent(query));
  }

  /// Limpia la búsqueda y muestra todas las solicitudes
  void _limpiarBusqueda() {
    _searchController.clear();
    _focusNode.unfocus();
    context.read<HomeBloc>().add(const ClearSearchEvent());
  }
}

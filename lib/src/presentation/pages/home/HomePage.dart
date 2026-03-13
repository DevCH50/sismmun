import 'package:sismmun/src/presentation/pages/home/bloc/HomeBloc.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeEvent.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeState.dart';
import 'package:sismmun/src/presentation/pages/home/widget/SolicitudItem.dart';
import 'package:sismmun/src/presentation/pages/home/widget/CloseSession.dart';
import 'package:sismmun/src/presentation/pages/home/widget/HomeDrawer.dart';
import 'package:sismmun/src/presentation/pages/home/widget/SearchSolicitudes.dart';
import 'package:sismmun/src/presentation/widgets/ResultDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';

class HomesPage extends StatefulWidget {
  const HomesPage({super.key});

  @override
  State<HomesPage> createState() => _HomesPageState();
}

class _HomesPageState extends State<HomesPage> {
  late HomeBloc bloc;

  void _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Control adicional
      builder: (context) => CloseSession(
        title: 'Cerrar Sesión',
        message: '¿Estás seguro que deseas cerrar sesión?',
        icon: Icons.logout,
        iconColor: Colors.orange,
        confirmText: 'Cerrar Sesión',
        cancelText: 'Cancelar',
        confirmButtonColor: Colors.red,
        confirmTextColor: Colors.white,
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (shouldLogout == true && mounted) {
      // ✅ Disparar evento de logout
      bloc.add(const HomeLogoutEvent());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<HomeBloc>(context);
    
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.uploadResultMessage != current.uploadResultMessage &&
          current.uploadResultMessage != null,
      listener: (context, state) {
        if (state.uploadResultMessage != null) {
          ResultDialog.show(
            context,
            type: state.uploadSuccess ? ResultType.success : ResultType.error,
            message: state.uploadResultMessage!,
          );
        }
      },
      child: Scaffold(
      drawer: HomeDrawer(onLogout: _handleLogout),
      appBar: AppBar(
        title: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            // Mostrar "Cargando..." mientras se cargan las solicitudes
            if (state.isLoading) {
              return const Text('Cargando...');
            }

            // Mostrar el número de solicitudes cuando ya estén cargadas
            if (state.solicitudes != null && state.solicitudes!.isNotEmpty) {
              // Si hay búsqueda activa, mostrar resultados filtrados
              if (state.isSearching) {
                final filtradas = state.solicitudesFiltradas?.length ?? 0;
                final total = state.solicitudes!.length;
                return Text('$filtradas de $total');
              }
              return Text(
                '${state.solicitudes!.length} ${state.solicitudes!.length == 1 ? 'Solicitud' : 'Solicitudes'}',
              );
            }

            // Si no hay solicitudes o hay error
            return const Text('Solicitudes');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeBloc>().add(const RefreshHomesList());
            },
          ),
          // IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 74, 144, 226), Color.fromARGB(255, 163, 206, 241)],
          ),
        ),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            // Estado de carga
            if (state.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text('Cargando Solicitudes...', style: TextStyle(color: Colors.white)),
                  ],
                ),
              );
            }

          // Estado de error
          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<HomeBloc>().add(const GetHomesList());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Sin Homes
          if (state.solicitudes == null || state.solicitudes!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay Solicituds registrados',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<HomeBloc>().add(const RefreshHomesList());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualizar'),
                  ),
                ],
              ),
            );
          }

          // Lista de Solicitudes con buscador
          final solicitudesAMostrar = state.solicitudesFiltradas ?? state.solicitudes!;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const RefreshHomesList());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Column(
              children: [
                // Buscador de solicitudes
                const SearchSolicitudes(),

                // Indicador de resultados de búsqueda
                if (state.isSearching)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, size: 16, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          '${solicitudesAMostrar.length} resultado${solicitudesAMostrar.length != 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Lista de solicitudes filtradas
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
                                onImageUploaded: () {
                                  context.read<HomeBloc>().add(
                                    const RefreshHomesList(),
                                  );
                                },
                                bloc: bloc,
                              );
                            },
                          ),
                  ),
              ],
            ),
          );
          },
        ),
      ),
    ),
    );
  }

  /// Widget que se muestra cuando no hay resultados de búsqueda
  Widget _buildSinResultados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white70,
          ),
          const SizedBox(height: 16),
          const Text(
            'No se encontraron solicitudes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Intenta con otro término de búsqueda',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

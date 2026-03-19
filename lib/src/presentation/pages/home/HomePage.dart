import 'package:sismmun/src/presentation/pages/home/bloc/HomeBloc.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeEvent.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeState.dart';
import 'package:sismmun/src/presentation/pages/home/widget/CloseSession.dart';
import 'package:sismmun/src/presentation/pages/home/widget/HomeDrawer.dart';
import 'package:sismmun/src/presentation/pages/home/widget/HomeCargandoWidget.dart';
import 'package:sismmun/src/presentation/pages/home/widget/HomeErrorWidget.dart';
import 'package:sismmun/src/presentation/pages/home/widget/HomeListaWidget.dart';
import 'package:sismmun/src/presentation/pages/home/widget/HomeSinSolicitudesWidget.dart';
import 'package:sismmun/src/presentation/widgets/ResultDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';

/// Página principal de la aplicación.
/// Orquesta los estados del [HomeBloc] delegando la UI a widgets especializados:
/// [HomeCargandoWidget], [HomeErrorWidget], [HomeSinSolicitudesWidget] y [HomeListaWidget].
class HomesPage extends StatefulWidget {
  const HomesPage({super.key});

  @override
  State<HomesPage> createState() => _HomesPageState();
}

class _HomesPageState extends State<HomesPage> {
  late HomeBloc bloc;

  /// Muestra el diálogo de confirmación y cierra sesión si el usuario confirma.
  void _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CloseSession(
        title: 'Cerrar Sesión',
        message: '¿Estás seguro que deseas cerrar sesión?',
        icon: Icons.logout,
        iconColor: Theme.of(context).colorScheme.tertiary,
        confirmText: 'Cerrar Sesión',
        cancelText: 'Cancelar',
        confirmButtonColor: Theme.of(context).colorScheme.error,
        confirmTextColor: Theme.of(context).colorScheme.onError,
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (shouldLogout == true && mounted) {
      bloc.add(const HomeLogoutEvent());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false,
      );
    }
  }

  /// Construye el título del AppBar según el estado actual del bloc.
  Widget _buildAppBarTitle(HomeState state) {
    if (state.isLoading) return const Text('Cargando...');

    if (state.solicitudes != null && state.solicitudes!.isNotEmpty) {
      if (state.isSearching) {
        final filtradas = state.solicitudesFiltradas?.length ?? 0;
        return Text('$filtradas de ${state.solicitudes!.length}');
      }
      final count = state.solicitudes!.length;
      return Text('$count ${count == 1 ? 'Solicitud' : 'Solicitudes'}');
    }

    return const Text('Solicitudes');
  }

  /// Selecciona el widget de cuerpo adecuado según el estado del bloc.
  Widget _buildBody(BuildContext context, HomeState state) {
    if (state.isLoading) return const HomeCargandoWidget();

    if (state.errorMessage != null) {
      return HomeErrorWidget(
        errorMessage: state.errorMessage!,
        onReintentar: () => context.read<HomeBloc>().add(const GetHomesList()),
      );
    }

    if (state.solicitudes == null || state.solicitudes!.isEmpty) {
      return HomeSinSolicitudesWidget(
        onActualizar: () =>
            context.read<HomeBloc>().add(const RefreshHomesList()),
      );
    }

    return HomeListaWidget(state: state, bloc: bloc);
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
            builder: (context, state) => _buildAppBarTitle(state),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  context.read<HomeBloc>().add(const RefreshHomesList()),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            final cs = Theme.of(context).colorScheme;
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    cs.primaryContainer.withValues(alpha: 0.35),
                    cs.surface,
                  ],
                ),
              ),
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) => _buildBody(context, state),
              ),
            );
          },
        ),
      ),
    );
  }
}

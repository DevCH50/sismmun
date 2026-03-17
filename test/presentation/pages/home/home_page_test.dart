// Tests de widget para HomePage (HomesPage)
// Verifica renderización de estados: cargando, error, vacío y con solicitudes
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sismmun/src/domain/models/Solicitud.dart';
import 'package:sismmun/src/domain/models/SolicitudesResponse.dart';
import 'package:sismmun/src/presentation/pages/home/HomePage.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeBloc.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeState.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeEvent.dart';

// Mock del HomeBloc para inyectar estados sin lógica real
class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}
class MockLoginBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {}

/// Construye una Solicitud de prueba
Solicitud _buildSolicitud({int id = 1}) => Solicitud(
  solicitudId: id,
  fechaIngreso: '2026-01-0$id',
  fechaUltimoEstatus: '2026-01-10',
  denuncia: 'Denuncia de prueba $id',
  dependenciaId: 1,
  dependencia: 'Obras Públicas',
  servicioId: 1,
  servicio: 'Bacheo',
  servicioUltimoEstatusId: 1,
  servicioUltimoEstatus: 'En proceso',
  ultimoEstatusId: 17,
  ultimoEstatus: 'Atendida',
  origenId: 1,
  origen: 'APP',
  latitud: '17.9',
  longitud: '-92.9',
  observaciones: '',
  imagenes: [],
  respuestas: [],
);

/// Envuelve HomesPage con los BLoCs necesarios
Widget _buildHomePage(HomeBloc homeBloc, LoginBloc loginBloc) {
  return MaterialApp(
    routes: {
      'login': (context) => const Scaffold(body: Text('Login')),
      'Homes': (context) => const Scaffold(body: Text('Homes')),
    },
    home: MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>.value(value: homeBloc),
        BlocProvider<LoginBloc>.value(value: loginBloc),
      ],
      child: const HomesPage(),
    ),
  );
}

void main() {
  late MockHomeBloc mockHomeBloc;
  late MockLoginBloc mockLoginBloc;

  setUp(() {
    mockHomeBloc = MockHomeBloc();
    mockLoginBloc = MockLoginBloc();
    when(() => mockLoginBloc.state).thenReturn(const LoginState());
  });

  tearDown(() {
    mockHomeBloc.close();
    mockLoginBloc.close();
  });

  group('HomesPage - estado de carga', () {
    testWidgets('muestra indicador de carga cuando isLoading=true', (tester) async {
      when(() => mockHomeBloc.state).thenReturn(
        const HomeState(isLoading: true),
      );

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Cargando Solicitudes...'), findsOneWidget);
    });

    testWidgets('AppBar muestra "Cargando..." durante la carga', (tester) async {
      when(() => mockHomeBloc.state).thenReturn(
        const HomeState(isLoading: true),
      );

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      expect(find.text('Cargando...'), findsOneWidget);
    });
  });

  group('HomesPage - estado de error', () {
    testWidgets('muestra mensaje de error cuando hay errorMessage', (tester) async {
      when(() => mockHomeBloc.state).thenReturn(
        const HomeState(errorMessage: 'Sin conexión al servidor'),
      );

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Sin conexión al servidor'), findsOneWidget);
    });

    testWidgets('muestra botón de reintentar en estado de error', (tester) async {
      when(() => mockHomeBloc.state).thenReturn(
        const HomeState(errorMessage: 'Error de red'),
      );

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('muestra ícono de error', (tester) async {
      when(() => mockHomeBloc.state).thenReturn(
        const HomeState(errorMessage: 'Error'),
      );

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  group('HomesPage - lista vacía', () {
    testWidgets('muestra mensaje cuando no hay solicitudes', (tester) async {
      when(() => mockHomeBloc.state).thenReturn(
        const HomeState(solicitudes: []),
      );

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      expect(find.text('No hay Solicituds registrados'), findsOneWidget);
    });

    testWidgets('muestra ícono cuando no hay solicitudes', (tester) async {
      when(() => mockHomeBloc.state).thenReturn(
        const HomeState(solicitudes: []),
      );

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      expect(find.byIcon(Icons.people_outline), findsOneWidget);
    });
  });

  group('HomesPage - con solicitudes', () {
    testWidgets('muestra el número de solicitudes en AppBar', (tester) async {
      final solicitudes = [_buildSolicitud(id: 1), _buildSolicitud(id: 2)];
      when(() => mockHomeBloc.state).thenReturn(
        HomeState(
          solicitudes: solicitudes,
          solicitudesFiltradas: solicitudes,
          solicitudesResponse: SolicitudesResponse(
            status: 200,
            msg: 'OK',
            solicitudes: solicitudes,
          ),
        ),
      );

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      expect(find.text('2 Solicitudes'), findsOneWidget);
    });

    testWidgets('muestra "Solicitud" en singular cuando hay 1', (tester) async {
      final solicitudes = [_buildSolicitud(id: 1)];
      when(() => mockHomeBloc.state).thenReturn(
        HomeState(
          solicitudes: solicitudes,
          solicitudesFiltradas: solicitudes,
          solicitudesResponse: SolicitudesResponse(
            status: 200,
            msg: 'OK',
            solicitudes: solicitudes,
          ),
        ),
      );

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      expect(find.text('1 Solicitud'), findsOneWidget);
    });

    testWidgets('muestra botón de refresh en AppBar', (tester) async {
      when(() => mockHomeBloc.state).thenReturn(const HomeState());

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      expect(find.byIcon(Icons.refresh), findsAtLeastNWidgets(1));
    });
  });

  group('HomesPage - búsqueda activa', () {
    testWidgets('muestra conteo de resultados cuando isSearching=true', (tester) async {
      final todas = [_buildSolicitud(id: 1), _buildSolicitud(id: 2), _buildSolicitud(id: 3)];
      final filtradas = [_buildSolicitud(id: 1)];

      when(() => mockHomeBloc.state).thenReturn(
        HomeState(
          solicitudes: todas,
          solicitudesFiltradas: filtradas,
          isSearching: true,
          searchQuery: 'prueba 1',
          solicitudesResponse: SolicitudesResponse(
            status: 200,
            msg: 'OK',
            solicitudes: todas,
          ),
        ),
      );

      await tester.pumpWidget(_buildHomePage(mockHomeBloc, mockLoginBloc));

      // AppBar muestra "1 de 3"
      expect(find.text('1 de 3'), findsOneWidget);
    });
  });
}

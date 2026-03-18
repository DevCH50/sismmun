// Tests unitarios del HomeBloc
// Verifica transiciones de estado para carga de solicitudes, búsqueda y subida de imágenes
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/models/Imagen.dart';
import 'package:sismmun/src/domain/models/Solicitud.dart';
import 'package:sismmun/src/domain/models/SolicitudesResponse.dart';
import 'package:sismmun/src/domain/models/SubirImagenRequest.dart';
import 'package:sismmun/src/domain/models/User.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:sismmun/src/domain/useCases/auth/GetUserSessionUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/LogoutUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/SaveUserSessionUseCase.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/GetSolicitudesUseCase.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/HomeUseCases.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/SolicitudUseCases.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/SubirImagenUseCase.dart';
import 'package:sismmun/src/domain/utils/Resource.dart' as res;
import 'package:sismmun/src/presentation/pages/home/bloc/HomeBloc.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeEvent.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeState.dart';

// Mocks
class MockGetSolicitudesUseCase extends Mock implements GetSolicitudesUseCase {}
class MockSubirImagenUseCase extends Mock implements SubirImagenUseCase {}
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSaveUserSessionUseCase extends Mock implements SaveUserSessionUseCase {}
class MockGetUserSessionUseCase extends Mock implements GetUserSessionUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

// Fallback values para mocktail
class FakeSubirImagenRequest extends Fake implements SubirImagenRequest {}

/// Crea una Solicitud de prueba
Solicitud _buildSolicitud({int id = 1}) => Solicitud(
  solicitudId: id,
  fechaIngreso: '2026-01-01',
  fechaUltimoEstatus: '2026-01-10',
  denuncia: 'Bache en calle $id',
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
  observaciones: 'Sin observaciones',
  imagenes: [],
  respuestas: [],
);

/// Crea una SolicitudesResponse de prueba
SolicitudesResponse _buildSolicitudesResponse({int count = 2}) =>
    SolicitudesResponse(
      status: 200,
      msg: 'OK',
      solicitudes: List.generate(count, (i) => _buildSolicitud(id: i + 1)),
    );

/// Crea un AuthResponse de prueba
AuthResponse _buildAuthResponse() => AuthResponse(
  status: 200,
  msg: 'OK',
  accessToken: 'test_token',
  tokenType: 'Bearer',
  apiVersion: '1.0',
  appVersion: '1.0.0',
  user: User(
    id: 1,
    username: 'testuser',
    email: 'test@test.com',
    nombre: 'Test',
    apPaterno: 'User',
    apMaterno: 'Demo',
    curp: 'TEST900101HTCRNN09',
    celulares: '9990000000',
    filenameThumb: null,
    roleIdArray: [1],
    dependenciaIdArray: [1],
    strGenero: 'M',
    fullName: 'Test User Demo',
  ),
);

void main() {
  late MockGetSolicitudesUseCase mockGetSolicitudes;
  late MockSubirImagenUseCase mockSubirImagen;
  late MockLoginUseCase mockLogin;
  late MockSaveUserSessionUseCase mockSave;
  late MockGetUserSessionUseCase mockGetSession;
  late MockLogoutUseCase mockLogout;

  setUpAll(() {
    registerFallbackValue(FakeSubirImagenRequest());
  });

  setUp(() {
    mockGetSolicitudes = MockGetSolicitudesUseCase();
    mockSubirImagen = MockSubirImagenUseCase();
    mockLogin = MockLoginUseCase();
    mockSave = MockSaveUserSessionUseCase();
    mockGetSession = MockGetUserSessionUseCase();
    mockLogout = MockLogoutUseCase();
  });

  HomeBloc buildBloc() => HomeBloc(
    HomeUseCases(getSolicitudes: mockGetSolicitudes),
    AuthUseCases(
      login: mockLogin,
      saveUserSession: mockSave,
      getUserSession: mockGetSession,
      logout: mockLogout,
    ),
    SolicitudUseCases(subirImagen: mockSubirImagen),
  );

  group('HomeBloc - GetHomesList', () {
    blocTest<HomeBloc, HomeState>(
      'emite isLoading=true y luego lista de solicitudes en éxito',
      setUp: () {
        when(() => mockGetSolicitudes.run()).thenAnswer(
          (_) async => res.Success(_buildSolicitudesResponse()),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const GetHomesList()),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.solicitudes, 'solicitudes', hasLength(2))
            .having((s) => s.errorMessage, 'errorMessage', isNull),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emite isLoading=true y luego errorMessage en caso de error',
      setUp: () {
        when(() => mockGetSolicitudes.run()).thenAnswer(
          (_) async => res.Error('Sin conexión'),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const GetHomesList()),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', 'Sin conexión'),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'inicializa solicitudesFiltradas igual a solicitudes',
      setUp: () {
        when(() => mockGetSolicitudes.run()).thenAnswer(
          (_) async => res.Success(_buildSolicitudesResponse(count: 3)),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const GetHomesList()),
      verify: (bloc) {
        final state = bloc.state;
        expect(state.solicitudesFiltradas?.length, state.solicitudes?.length);
      },
    );
  });

  // Estado pre-cargado con solicitudes para tests de búsqueda
  HomeState _estadoConSolicitudes({int count = 3}) {
    final solicitudes = List.generate(count, (i) => _buildSolicitud(id: i + 1));
    return HomeState(
      solicitudes: solicitudes,
      solicitudesFiltradas: solicitudes,
      isLoading: false,
    );
  }

  group('HomeBloc - SearchSolicitudesEvent', () {
    blocTest<HomeBloc, HomeState>(
      'filtra solicitudes por texto en la denuncia',
      build: buildBloc,
      seed: () => _estadoConSolicitudes(count: 3),
      act: (bloc) => bloc.add(const SearchSolicitudesEvent('Bache en calle 1')),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isSearching, 'isSearching', true)
            .having((s) => s.solicitudesFiltradas, 'filtradas', hasLength(1)),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'muestra todas las solicitudes cuando la búsqueda está vacía (desde búsqueda activa)',
      build: buildBloc,
      // Semilla con búsqueda activa: solo 1 resultado visible
      seed: () {
        final todas = List.generate(3, (i) => _buildSolicitud(id: i + 1));
        return HomeState(
          solicitudes: todas,
          solicitudesFiltradas: [todas.first], // búsqueda activa
          isSearching: true,
          searchQuery: 'algo',
        );
      },
      act: (bloc) => bloc.add(const SearchSolicitudesEvent('')),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isSearching, 'isSearching', false)
            .having((s) => s.solicitudesFiltradas, 'filtradas', hasLength(3)),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'filtra solicitudes por ID numérico exacto',
      build: buildBloc,
      seed: () => _estadoConSolicitudes(count: 5),
      act: (bloc) => bloc.add(const SearchSolicitudesEvent('3')),
      verify: (bloc) {
        expect(bloc.state.isSearching, true);
        expect(bloc.state.solicitudesFiltradas, isNotEmpty);
      },
    );
  });

  group('HomeBloc - ClearSearchEvent', () {
    blocTest<HomeBloc, HomeState>(
      'limpia la búsqueda y muestra todas las solicitudes',
      build: buildBloc,
      seed: () {
        final solicitudes = List.generate(4, (i) => _buildSolicitud(id: i + 1));
        return HomeState(
          solicitudes: solicitudes,
          solicitudesFiltradas: [solicitudes.first], // búsqueda activa con 1 resultado
          isSearching: true,
          searchQuery: 'calle 1',
        );
      },
      act: (bloc) => bloc.add(const ClearSearchEvent()),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isSearching, 'isSearching', false)
            .having((s) => s.searchQuery, 'searchQuery', '')
            .having((s) => s.solicitudesFiltradas, 'filtradas', hasLength(4)),
      ],
    );
  });

  group('HomeBloc - SubirImagenEvent', () {
    final request = SubirImagenRequest(
      solicitudId: 101,
      dependenciaId: 2,
      estatusId: 17,
      servicioId: 5,
      imagenPath: '/tmp/test.jpg',
      observaciones: 'Foto de prueba',
      tipoFoto: TipoFoto.despues,
    );

    blocTest<HomeBloc, HomeState>(
      'emite isUploadingImage=true y luego uploadSuccess=true en éxito',
      setUp: () {
        when(() => mockSubirImagen.run(any())).thenAnswer(
          (_) async => res.Success(Imagen(
            fecha: '2026-03-17',
            urlImagen: 'http://test.com/img.jpg',
            urlThumb: 'http://test.com/thumb.jpg',
            status: 1,
            msg: 'Imagen subida correctamente',
          )),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(SubirImagenEvent(request)),
      expect: () => [
        isA<HomeState>().having((s) => s.isUploadingImage, 'isUploadingImage', true),
        isA<HomeState>()
            .having((s) => s.isUploadingImage, 'isUploadingImage', false)
            .having((s) => s.uploadSuccess, 'uploadSuccess', true),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emite uploadSuccess=false cuando el servidor rechaza la imagen',
      setUp: () {
        when(() => mockSubirImagen.run(any())).thenAnswer(
          (_) async => res.Success(Imagen(
            fecha: '2026-03-17',
            urlImagen: '',
            urlThumb: '',
            status: 0,
            msg: 'Error al procesar imagen',
          )),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(SubirImagenEvent(request)),
      expect: () => [
        isA<HomeState>().having((s) => s.isUploadingImage, 'isUploadingImage', true),
        isA<HomeState>()
            .having((s) => s.isUploadingImage, 'isUploadingImage', false)
            .having((s) => s.uploadSuccess, 'uploadSuccess', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emite uploadSuccess=false en caso de error de red',
      setUp: () {
        when(() => mockSubirImagen.run(any())).thenAnswer(
          (_) async => res.Error('Error de conexión'),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(SubirImagenEvent(request)),
      expect: () => [
        isA<HomeState>().having((s) => s.isUploadingImage, 'isUploadingImage', true),
        isA<HomeState>()
            .having((s) => s.isUploadingImage, 'isUploadingImage', false)
            .having((s) => s.uploadSuccess, 'uploadSuccess', false)
            .having((s) => s.uploadResultMessage, 'uploadResultMessage', contains('Error de conexión')),
      ],
    );
  });

  group('HomeBloc - HomeLogoutEvent', () {
    blocTest<HomeBloc, HomeState>(
      'ejecuta logout sin emitir nuevos estados',
      setUp: () {
        when(() => mockLogout.run()).thenAnswer((_) async => true);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const HomeLogoutEvent()),
      expect: () => <HomeState>[],
      verify: (_) => verify(() => mockLogout.run()).called(1),
    );
  });

  group('HomeState - valores iniciales', () {
    test('HomeState.initial() tiene valores correctos', () {
      final state = HomeState.initial();
      expect(state.solicitudes, isNull);
      expect(state.isLoading, false);
      expect(state.isUploadingImage, false);
      expect(state.isSearching, false);
      expect(state.searchQuery, '');
      expect(state.uploadSuccess, false);
    });
  });
}

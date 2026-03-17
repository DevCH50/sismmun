// Tests unitarios del LoginBloc
// Verifica las transiciones de estado para autenticación
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/models/User.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:sismmun/src/domain/useCases/auth/GetUserSessionUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/LogoutUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/SaveUserSessionUseCase.dart';
import 'package:sismmun/src/domain/utils/Resource.dart' as res;
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:sismmun/src/presentation/utils/BlocForItem.dart';

// Mocks
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSaveUserSessionUseCase extends Mock implements SaveUserSessionUseCase {}
class MockGetUserSessionUseCase extends Mock implements GetUserSessionUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

/// Crea un AuthResponse de prueba
AuthResponse _buildAuthResponse({int id = 1}) => AuthResponse(
  status: 200,
  msg: 'Login exitoso',
  accessToken: 'token_test_$id',
  tokenType: 'Bearer',
  apiVersion: '1.0',
  appVersion: '1.0.0',
  user: User(
    id: id,
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

/// Crea AuthUseCases con los mocks inyectados
AuthUseCases _buildAuthUseCases({
  required MockLoginUseCase login,
  required MockSaveUserSessionUseCase save,
  required MockGetUserSessionUseCase getSession,
  required MockLogoutUseCase logout,
}) =>
    AuthUseCases(
      login: login,
      saveUserSession: save,
      getUserSession: getSession,
      logout: logout,
    );

void main() {
  late MockLoginUseCase mockLogin;
  late MockSaveUserSessionUseCase mockSave;
  late MockGetUserSessionUseCase mockGetSession;
  late MockLogoutUseCase mockLogout;

  setUp(() {
    mockLogin = MockLoginUseCase();
    mockSave = MockSaveUserSessionUseCase();
    mockGetSession = MockGetUserSessionUseCase();
    mockLogout = MockLogoutUseCase();
  });

  LoginBloc buildBloc() => LoginBloc(
    _buildAuthUseCases(
      login: mockLogin,
      save: mockSave,
      getSession: mockGetSession,
      logout: mockLogout,
    ),
  );

  group('LoginBloc - LoginInitialEvent', () {
    blocTest<LoginBloc, LoginState>(
      'emite estado con formKey cuando no hay sesión activa',
      setUp: () {
        when(() => mockGetSession.run()).thenAnswer((_) async => null);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const LoginInitialEvent()),
      expect: () => [
        isA<LoginState>().having((s) => s.response, 'response', isNull),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emite Success cuando hay sesión activa',
      setUp: () {
        when(() => mockGetSession.run())
            .thenAnswer((_) async => _buildAuthResponse());
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const LoginInitialEvent()),
      expect: () => [
        isA<LoginState>(),
        isA<LoginState>().having(
          (s) => s.response,
          'response',
          isA<res.Success>(),
        ),
      ],
    );
  });

  group('LoginBloc - EmailChanged', () {
    blocTest<LoginBloc, LoginState>(
      'emite error cuando el email está vacío',
      setUp: () {
        when(() => mockGetSession.run()).thenAnswer((_) async => null);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        const EmailChanged(email: BlocForItem(value: '')),
      ),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.email.error,
          'email.error',
          isNotNull,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emite sin error cuando el email tiene valor',
      setUp: () {
        when(() => mockGetSession.run()).thenAnswer((_) async => null);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        const EmailChanged(email: BlocForItem(value: 'usuario123')),
      ),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.email.error,
          'email.error',
          isNull,
        ),
      ],
    );
  });

  group('LoginBloc - PasswordChanged', () {
    blocTest<LoginBloc, LoginState>(
      'emite error cuando la contraseña tiene menos de 6 caracteres',
      setUp: () {
        when(() => mockGetSession.run()).thenAnswer((_) async => null);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        const PasswordChanged(password: BlocForItem(value: '123')),
      ),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.password.error,
          'password.error',
          isNotNull,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emite sin error cuando la contraseña tiene 6 o más caracteres',
      setUp: () {
        when(() => mockGetSession.run()).thenAnswer((_) async => null);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        const PasswordChanged(password: BlocForItem(value: 'password123')),
      ),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.password.error,
          'password.error',
          isNull,
        ),
      ],
    );
  });

  group('LoginBloc - LoginSubmitted', () {
    blocTest<LoginBloc, LoginState>(
      'emite Loading y luego Success en login exitoso',
      setUp: () {
        when(() => mockGetSession.run()).thenAnswer((_) async => null);
        when(() => mockLogin.run(any(), any())).thenAnswer(
          (_) async => res.Success(_buildAuthResponse()),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.response,
          'response',
          isA<res.Loading>(),
        ),
        isA<LoginState>().having(
          (s) => s.response,
          'response',
          isA<res.Success>(),
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emite Loading y luego Error en login fallido',
      setUp: () {
        when(() => mockGetSession.run()).thenAnswer((_) async => null);
        when(() => mockLogin.run(any(), any())).thenAnswer(
          (_) async => res.Error('Credenciales incorrectas'),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.response,
          'response',
          isA<res.Loading>(),
        ),
        isA<LoginState>().having(
          (s) => s.response,
          'response',
          isA<res.Error>(),
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'NO hay demora de 5 segundos en el login',
      setUp: () {
        when(() => mockGetSession.run()).thenAnswer((_) async => null);
        when(() => mockLogin.run(any(), any())).thenAnswer(
          (_) async => res.Success(_buildAuthResponse()),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const LoginSubmitted()),
      // Con el fix del delay de 5s, debe emitir Loading y Success rápidamente
      expect: () => [
        isA<LoginState>().having((s) => s.response, 'response', isA<res.Loading>()),
        isA<LoginState>().having((s) => s.response, 'response', isA<res.Success>()),
      ],
    );
  });

  group('LoginBloc - CheckSession', () {
    blocTest<LoginBloc, LoginState>(
      'emite Success cuando hay sesión válida',
      setUp: () {
        when(() => mockGetSession.run())
            .thenAnswer((_) async => _buildAuthResponse(id: 5));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CheckSession()),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.response,
          'response',
          isA<res.Success>(),
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emite state con response null cuando no hay sesión',
      setUp: () {
        when(() => mockGetSession.run()).thenAnswer((_) async => null);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CheckSession()),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.response,
          'response',
          isNull,
        ),
      ],
    );
  });
}

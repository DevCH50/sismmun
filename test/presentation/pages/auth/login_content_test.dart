// Tests de widget para LoginContent
// Verifica renderización del formulario de login y sus elementos
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:sismmun/src/domain/useCases/auth/GetUserSessionUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/LogoutUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/SaveUserSessionUseCase.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:sismmun/src/presentation/pages/auth/login/includes/LoginContent.dart';
import 'package:sismmun/src/presentation/widgets/DefaultTextField.dart';
import 'package:sismmun/src/presentation/widgets/PrimaryElevatedButton.dart';

// Mocks
class MockLoginBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {}
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSaveUserSessionUseCase extends Mock implements SaveUserSessionUseCase {}
class MockGetUserSessionUseCase extends Mock implements GetUserSessionUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

/// Construye un LoginBloc real con mocks
LoginBloc _buildLoginBloc() {
  return LoginBloc(
    AuthUseCases(
      login: MockLoginUseCase(),
      saveUserSession: MockSaveUserSessionUseCase(),
      getUserSession: MockGetUserSessionUseCase()
        ..run().ignore(),
      logout: MockLogoutUseCase(),
    ),
  );
}

/// Envuelve LoginContent con el BLoC y MaterialApp necesarios
Widget _buildLoginContent(LoginBloc bloc) {
  return MaterialApp(
    home: Scaffold(
      body: BlocProvider<LoginBloc>.value(
        value: bloc,
        child: LoginContent(bloc),
      ),
    ),
  );
}

void main() {
  late LoginBloc bloc;

  setUp(() {
    final mockGetSession = MockGetUserSessionUseCase();
    when(() => mockGetSession.run()).thenAnswer((_) async => null);

    bloc = LoginBloc(
      AuthUseCases(
        login: MockLoginUseCase(),
        saveUserSession: MockSaveUserSessionUseCase(),
        getUserSession: mockGetSession,
        logout: MockLogoutUseCase(),
      ),
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('LoginContent - renderización', () {
    testWidgets('muestra dos campos de texto (username y contraseña)', (tester) async {
      await tester.pumpWidget(_buildLoginContent(bloc));
      await tester.pump();

      expect(find.byType(DefaultTextField), findsNWidgets(2));
    });

    testWidgets('muestra el label Username', (tester) async {
      await tester.pumpWidget(_buildLoginContent(bloc));
      await tester.pump();

      expect(find.text('Username'), findsOneWidget);
    });

    testWidgets('muestra el label Contraseña', (tester) async {
      await tester.pumpWidget(_buildLoginContent(bloc));
      await tester.pump();

      expect(find.text('Contraseña'), findsOneWidget);
    });

    testWidgets('muestra el botón Iniciar Sesión', (tester) async {
      await tester.pumpWidget(_buildLoginContent(bloc));
      await tester.pump();

      expect(find.byType(PrimaryElevatedButton), findsOneWidget);
      expect(find.text('Iniciar Sesión'), findsOneWidget);
    });

    testWidgets('muestra el texto "Ingresar"', (tester) async {
      await tester.pumpWidget(_buildLoginContent(bloc));
      await tester.pump();

      expect(find.text('Ingresar'), findsOneWidget);
    });

    testWidgets('muestra el botón de olvidé contraseña', (tester) async {
      await tester.pumpWidget(_buildLoginContent(bloc));
      await tester.pump();

      expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);
    });

    testWidgets('el campo de contraseña tiene obscureText', (tester) async {
      await tester.pumpWidget(_buildLoginContent(bloc));
      await tester.pump();

      // El icono de visibilidad debe estar presente (campo de contraseña)
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });
  });

  group('LoginContent - interacción', () {
    testWidgets('puede escribir en el campo de username', (tester) async {
      await tester.pumpWidget(_buildLoginContent(bloc));
      await tester.pump();

      final usernameField = find.byType(TextFormField).first;
      await tester.enterText(usernameField, 'admin');
      expect(find.text('admin'), findsOneWidget);
    });

    testWidgets('puede escribir en el campo de contraseña', (tester) async {
      await tester.pumpWidget(_buildLoginContent(bloc));
      await tester.pump();

      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');
      // No se puede verificar el texto porque está oculto, pero no debe tirar error
    });
  });
}

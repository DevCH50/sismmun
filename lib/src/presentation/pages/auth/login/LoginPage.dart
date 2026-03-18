import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:sismmun/src/presentation/pages/auth/login/includes/LoginBackground.dart';
import 'package:sismmun/src/presentation/pages/auth/login/includes/LoginContent.dart';
import 'package:sismmun/src/presentation/pages/auth/login/includes/LoginResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc? bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<LoginBloc>(context);

    // keyboardHeight se usa para extender el fondo detrás del teclado
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      // true: el body encoge cuando aparece el teclado → Flutter hace scroll
      // automático al campo enfocado sin intervención manual
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Fondo extendido con bottom negativo para cubrir también detrás
          // del teclado aunque el Scaffold haya encogido el body
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: -keyboardHeight,
            child: const LoginBackGround(),
          ),

          // Listener de respuesta (no visual)
          LoginResponse(bloc),

          // SafeArea + SingleChildScrollView: Flutter mueve automáticamente
          // el scroll para que el campo activo quede siempre visible
          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(child: LoginContent(bloc)),
            ),
          ),
        ],
      ),
    );
  }
}

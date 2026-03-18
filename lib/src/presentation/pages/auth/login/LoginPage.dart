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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Fondo siempre cubre toda la pantalla
          const Positioned.fill(child: LoginBackGround()),

          // Listener de respuesta (no visual, solo reacciona a eventos del BLoC)
          LoginResponse(bloc),

          // Formulario scrolleable — sube cuando aparece el teclado
          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Center(
                  child: LoginContent(bloc),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

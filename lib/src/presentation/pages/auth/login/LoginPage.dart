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

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // false: el Stack no encoge, el fondo siempre llena la pantalla
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Fondo siempre cubre toda la pantalla
          const Positioned.fill(child: LoginBackGround()),

          // Listener de respuesta (no visual)
          LoginResponse(bloc),

          // Formulario: padding bottom = altura del teclado → el contenido sube
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: SafeArea(
                child: Center(child: LoginContent(bloc)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

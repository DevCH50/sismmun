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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Cuando aparece el teclado, hace scroll al final para que el botón
  /// "Iniciar Sesión" (debajo del campo de contraseña) quede visible.
  void _scrollAlFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<LoginBloc>(context);

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Cada vez que el teclado aparece, desplaza hasta el final del scroll
    if (keyboardHeight > 0) _scrollAlFinal();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Fondo extendido para cubrir también detrás del teclado
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: -keyboardHeight,
            child: const LoginBackGround(),
          ),

          // Listener de respuesta (no visual)
          LoginResponse(bloc),

          // Scroll controlado: al aparecer el teclado lleva el botón a la vista
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
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

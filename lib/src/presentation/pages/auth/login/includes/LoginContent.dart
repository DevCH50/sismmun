import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:sismmun/src/presentation/utils/BlocForItem.dart';
import 'package:sismmun/src/presentation/widgets/DefaultTextField.dart';
import 'package:sismmun/src/presentation/widgets/LogoRedondeUno.dart';
import 'package:sismmun/src/presentation/widgets/PrimaryElevatedButton.dart';
import 'package:sismmun/src/presentation/widgets/ResultDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginContent extends StatelessWidget {
  final LoginBloc? bloc;

  const LoginContent(this.bloc, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Form(
          key: state.formKey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white54.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            margin: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(Icons.person, size: 125, color: Colors.white),
                  const LogoRedondoUno(
                    blurRadius: 10,
                    spreadRadius: 2,
                    paddingEdgeInsets: 10,
                    marginBottom: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: const Text(
                      'Ingresar',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  DefaultTextField(
                    label: 'Username',
                    icon: Icons.email,
                    // errorText: asyncSnapshot.error?.toString(),
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      bloc?.add(EmailChanged(email: BlocForItem(value: text)));
                    },
                    validator: (value) {
                      return state.email.error;
                    },
                  ),
                  const SizedBox(height: 10),
                  DefaultTextField(
                    label: 'Contraseña',
                    icon: Icons.lock,
                    // errorText: asyncSnapshot.error?.toString(),
                    obscureText: true,
                    onChanged: (text) {
                      bloc?.add(
                        PasswordChanged(password: BlocForItem(value: text)),
                      );
                    },
                    validator: (value) {
                      return state.password.error;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(
                      context,
                    ).size.width, // Make button full width
                    child: PrimaryElevatedButton(
                      text: 'Iniciar Sesión',
                      onPressed: () {
                        if (bloc?.state.formKey?.currentState?.validate() ??
                            false) {
                          bloc?.add(const LoginSubmitted());
                        } else {
                          ResultDialog.warning(
                            context,
                            message: 'Por favor, completa todos los campos.',
                          );
                        }
                      },
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
            ),
          ),
        );
      },
    );
  }
}

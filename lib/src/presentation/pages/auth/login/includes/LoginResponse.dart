import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:sismmun/src/presentation/widgets/ResultDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget que escucha el estado del LoginBloc y reacciona a los cambios
/// Muestra cargando, navega en éxito, o muestra ResultDialog en error
class LoginResponse extends StatelessWidget {
  final LoginBloc? bloc;

  const LoginResponse(this.bloc, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.response != current.response,
      listener: (context, state) {
        final responseState = state.response;

        if (responseState is Success) {
          if (responseState.data.status == 1) {
            final data = responseState.data as AuthResponse;
            bloc?.add(LoginSaveUserSession(authResponse: data));
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, 'Homes', (route) => false);
              }
            });
          } else {
            // Login exitoso pero sin acceso
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                ResultDialog.error(context, message: responseState.data.msg);
              }
            });
          }
        } else if (responseState is Error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              ResultDialog.error(context, message: responseState.msg);
            }
          });
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) =>
            (previous.response is Loading) != (current.response is Loading),
        builder: (context, state) {
          if (state.response is Loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

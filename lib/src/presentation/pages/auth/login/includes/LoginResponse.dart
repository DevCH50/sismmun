import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginResponse extends StatelessWidget {
  final LoginBloc? bloc;

  const LoginResponse(this.bloc, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final responseState = state.response;
        String message = '';
        Color bgColor = Colors.transparent;
        if (responseState is Loading) {
          return const Center(child: CircularProgressIndicator(color: Colors.blue));
        } else if (responseState is Success) {
          if (responseState.data.status == 1) {
            final data = responseState.data as AuthResponse;
            bloc?.add(LoginSaveUserSession(authResponse: data));
            // bloc?.add(LoginFormReset());
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushNamed(context, 'Homes');
            });
          } else {
            message = responseState.data.msg;
            bgColor = Colors.red;
            Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: bgColor,
            );
          }
        } else if (responseState is Error) {
          message = responseState.msg;
          bgColor = Colors.red;
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: bgColor,
          );
        }

        return const SizedBox.shrink(); // Return an empty widget
      },
    );
  }
}

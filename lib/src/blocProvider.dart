import 'package:sismmun/injection.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/HomeUseCases.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/SolicitudUseCases.dart'
    show SolicitudUseCases;
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeBloc.dart';
import 'package:sismmun/src/presentation/pages/home/bloc/HomeEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<LoginBloc>(
    create: (context) =>
        LoginBloc(locator<AuthUseCases>())..add(const LoginInitialEvent()),
  ),
  BlocProvider<HomeBloc>(
    create: (context) =>
        HomeBloc(locator<HomeUseCases>(), locator<AuthUseCases>(), locator<SolicitudUseCases>())
          ..add(const GetHomesList()),
  ),
];

import 'package:sismmun/src/data/dataSource/local/ImageCompressor.dart';
import 'package:sismmun/src/data/dataSource/local/SharedPref.dart';
import 'package:sismmun/src/data/dataSource/remote/services/HomeService.dart';
import 'package:sismmun/src/data/dataSource/remote/services/SolicitudService.dart';
import 'package:sismmun/src/data/repository/AuthRepositoryImpl.dart';
import 'package:sismmun/src/data/dataSource/remote/services/AuthService.dart';
import 'package:sismmun/src/data/repository/HomeRepositoryImpl.dart';
import 'package:sismmun/src/data/repository/SolicitudRepositoryImpl.dart';
import 'package:sismmun/src/domain/repository/AuthRepository.dart';
import 'package:sismmun/src/domain/repository/HomeRepository.dart';
import 'package:sismmun/src/domain/repository/SolicitudRepository.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/GetSolicitudesUseCase.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/HomeUseCases.dart';
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:sismmun/src/domain/useCases/auth/GetUserSessionUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/LogoutUseCase.dart';
import 'package:sismmun/src/domain/useCases/auth/SaveUserSessionUseCase.dart';
import 'package:injectable/injectable.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/EliminarImagenUseCase.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/SolicitudUseCases.dart';
import 'package:sismmun/src/domain/useCases/solicitudes/SubirImagenUseCase.dart';

@module
abstract class AppModule {
  @injectable
  SharedPref get sharedPref => SharedPref();

  @injectable
  AuthService get authService => AuthService();

  @injectable
  AuthRepository get authRepository =>
      AuthRepositoryImpl(authService, sharedPref);

  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
    login: LoginUseCase(authRepository),
    saveUserSession: SaveUserSessionUseCase(authRepository),
    getUserSession: GetUserSessionUseCase(authRepository),
    logout: LogoutUseCase(authRepository),
  );

  @injectable
  HomeService get homeService => HomeService(sharedPref, authUseCases);

  @injectable
  HomeRepository get homeRepository => HomeRepositoryImpl(homeService);

  @injectable
  HomeUseCases get homeUseCases =>
      HomeUseCases(getSolicitudes: GetSolicitudesUseCase(homeRepository));


  // SOLICITUDES y SUBIR IMAGEN
  
  @injectable
  SolicitudService get solicitudService => SolicitudService(authUseCases);

  @injectable
  ImageCompressor get imageCompressor => ImageCompressor();
  
  @injectable
  SolicitudRepository get solicitudRepository => SolicitudRepositoryImpl(solicitudService,imageCompressor,sharedPref);

  @injectable
  SolicitudUseCases get solicitudUseCases => SolicitudUseCases(
    subirImagen: SubirImagenUseCase(solicitudRepository),
    eliminarImagen: EliminarImagenUseCase(solicitudRepository),
  );



}

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sismmun/src/data/dataSource/local/ImageCompressor.dart'
    as _i172;
import 'package:sismmun/src/data/dataSource/local/SharedPref.dart' as _i203;
import 'package:sismmun/src/data/dataSource/remote/services/AuthService.dart'
    as _i681;
import 'package:sismmun/src/data/dataSource/remote/services/HomeService.dart'
    as _i926;
import 'package:sismmun/src/data/dataSource/remote/services/SolicitudService.dart'
    as _i981;
import 'package:sismmun/src/di/AppModule.dart' as _i990;
import 'package:sismmun/src/domain/repository/AuthRepository.dart' as _i159;
import 'package:sismmun/src/domain/repository/HomeRepository.dart' as _i286;
import 'package:sismmun/src/domain/repository/SolicitudRepository.dart'
    as _i628;
import 'package:sismmun/src/domain/useCases/auth/AuthUseCases.dart' as _i80;
import 'package:sismmun/src/domain/useCases/solicitudes/HomeUseCases.dart'
    as _i216;
import 'package:sismmun/src/domain/useCases/solicitudes/SolicitudUseCases.dart'
    as _i335;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i203.SharedPref>(() => appModule.sharedPref);
    gh.factory<_i681.AuthService>(() => appModule.authService);
    gh.factory<_i159.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i80.AuthUseCases>(() => appModule.authUseCases);
    gh.factory<_i926.HomeService>(() => appModule.homeService);
    gh.factory<_i286.HomeRepository>(() => appModule.homeRepository);
    gh.factory<_i216.HomeUseCases>(() => appModule.homeUseCases);
    gh.factory<_i981.SolicitudService>(() => appModule.solicitudService);
    gh.factory<_i172.ImageCompressor>(() => appModule.imageCompressor);
    gh.factory<_i628.SolicitudRepository>(() => appModule.solicitudRepository);
    gh.factory<_i335.SolicitudUseCases>(() => appModule.solicitudUseCases);
    return this;
  }
}

class _$AppModule extends _i990.AppModule {}

import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/repository/AuthRepository.dart';

class GetUserSessionUseCase {
  final AuthRepository authRepository;

  GetUserSessionUseCase(this.authRepository);

  Future<AuthResponse?> run() => authRepository.getUserSession();
}

import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/repository/AuthRepository.dart';

class SaveUserSessionUseCase {
  final AuthRepository authRepository;

  SaveUserSessionUseCase(this.authRepository);

  Future<void> run(AuthResponse authResponse) =>
      authRepository.saveUserSession(authResponse);
}

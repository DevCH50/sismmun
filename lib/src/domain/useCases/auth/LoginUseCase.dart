import 'package:sismmun/src/domain/repository/AuthRepository.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

class LoginUseCase {
  AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Resource<dynamic>> run(String username, String password) =>
      repository.login(username, password);
}

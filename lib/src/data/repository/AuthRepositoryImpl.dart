import 'package:sismmun/src/data/dataSource/local/SharedPref.dart';
import 'package:sismmun/src/data/dataSource/remote/services/AuthService.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/models/User.dart';
import 'package:sismmun/src/domain/repository/AuthRepository.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final SharedPref sharedPref;

  AuthRepositoryImpl(this.authService, this.sharedPref);

  @override
  Future<Resource> login(String username, String password) {
    return authService.login(username, password);
  }

  @override
  Future<Resource> register(User user) {
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse?> getUserSession() async {
    final data = await sharedPref.read('user');
    if (data != null) {
      final AuthResponse authResponse = AuthResponse.fromJson(data);
      return authResponse;
    }
    return null;
  }

  @override
  Future<void> saveUserSession(AuthResponse authResponse) async {
    sharedPref.save('user', authResponse.toJson());
  }

  @override
  Future<bool> logout() async {
    return await sharedPref.remove('user');
  }
}

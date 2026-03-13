import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/models/User.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

// Interface para la capa de datos
abstract class AuthRepository {
  Future<AuthResponse?> getUserSession();
  Future<void> saveUserSession(AuthResponse authResponse);
  Future<Resource> login(String username, String password);
  Future<Resource> register(User user);
  Future<bool> logout();
}

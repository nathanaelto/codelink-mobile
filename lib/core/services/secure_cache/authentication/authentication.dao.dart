
import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.dao.interface.dart';
import 'package:codelink_mobile/core/services/env/environment.service.dart';
import 'package:codelink_mobile/core/services/secure_cache/secure_cache.service.dart';

class AuthenticationDao extends SecureCacheService implements IAuthenticationDao {
  static final String seed = EnvironmentService.get(EnvironmentVariable.SEED);

  static final String tokenKey = '${seed}_TOKEN_KEY';
  static final String loginKey = '${seed}_LOGIN_KEY';
  static final String passwordKey = '${seed}_PASSWORD_KEY';
  static final String userIdKey = '${seed}_USER_ID';

  @override
  Future<void> storeToken(String token) async {
    set(tokenKey, token);
  }

  @override
  Future<void> storeCredentials(String login, String password) async {
    set(loginKey, login);
    set(passwordKey, password);
  }

  @override
  Future<String?> getToken() async {
    return get(tokenKey);
  }

  @override
  Future<String?> getLogin() async {
    return get(loginKey);
  }

  @override
  Future<String?> getPassword() async {
    return get(passwordKey);
  }

  @override
  Future<void> deleteAll() async {
    await delete(tokenKey);
    await delete(loginKey);
    await delete(passwordKey);
    await delete(userIdKey);
  }

  @override
  Future<String?> getUserId() async {
    return get(userIdKey);
  }

  @override
  Future<void> storeUserId(String userId) async {
    await set(userIdKey, userId);
  }

}

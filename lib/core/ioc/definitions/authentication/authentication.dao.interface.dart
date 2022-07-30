abstract class IAuthenticationDao {
  Future<void> storeToken(String token);
  Future<String?> getToken();
  Future<void> storeCredentials(String login, String password);
  Future<String?> getLogin();
  Future<String?> getPassword();
  Future<String?> getUserId();
  Future<void> storeUserId(String userId);
  Future<void> deleteAll();
}
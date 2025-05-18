abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<void> register(String username, String password);
  Future<bool> isLoggedIn();
}

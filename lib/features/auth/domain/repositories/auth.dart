import 'package:clean_arc_madura/features/auth/data/models/singin_request.dart';

abstract class AuthRepository {
  Future<void> login(SinginRequest request);
  Future<void> logout();
  Future<void> register(String username, String password);
  Future<bool> isLoggedIn();
}

import 'package:clean_arc_madura/features/auth/data/models/login_request.dart';
import 'package:clean_arc_madura/features/auth/data/models/register_request.dart';

abstract class AuthRepository {
  Future<void> login(LoginRequest request);
  Future<void> logout();
  Future<void> register(RegisterRequest request);
  Future<bool> isLoggedIn();
}

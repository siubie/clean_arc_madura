import 'package:clean_arc_madura/features/auth/data/datasources/auth_api_service.dart';
import 'package:clean_arc_madura/features/auth/data/models/singin_request.dart';
import 'package:clean_arc_madura/features/auth/domain/repositories/auth.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<bool> isLoggedIn() {
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> register(String username, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Either> login(SinginRequest request) async {
    Either result = await AuthApiServiceImpl().login(request);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) async {
        Response response = data;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('token', response.data['token']);
        return Right(response);
      },
    );
  }
}

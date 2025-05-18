import 'package:clean_arc_madura/core/constants/api_urls.dart';
import 'package:clean_arc_madura/core/network/dio_client.dart';
import 'package:clean_arc_madura/features/auth/data/models/login_request.dart';
import 'package:clean_arc_madura/features/auth/data/models/register_request.dart';
import 'package:clean_arc_madura/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class AuthApiService {
  Future<void> login(LoginRequest request);
  Future<void> logout();
  Future<void> register(RegisterRequest request);
}

class AuthApiServiceImpl implements AuthApiService {
  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> register(RegisterRequest request) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Either> login(LoginRequest request) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrls.login,
        data: request.toJson(),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    } catch (e) {
      return Left(e);
    }
  }
}

import 'package:clean_arc_madura/core/network/dio_client.dart';
import 'package:clean_arc_madura/features/auth/data/datasources/auth_api_service.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Register your services and repositories here
  // Example:
  // sl.registerLazySingleton<NetworkService>(() => NetworkService());
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerSingleton<DioClient>(DioClient());
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
}

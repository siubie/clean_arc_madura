import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/network/dio_client.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DioClient _dioClient = DioClient();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final loginData = {'email': event.email, 'password': event.password};

      final response = await _dioClient.post(ApiUrls.login, data: loginData);

      // Check if response contains token or access_token
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final token = data['token'] ?? data['access_token'] ?? '';

        emit(LoginSuccess(token: token.toString()));
      } else {
        emit(const LoginFailure(error: 'Login failed. Please try again.'));
      }
    } catch (e) {
      String errorMessage = 'Login failed';

      if (e is DioException) {
        errorMessage = e.toString();
      } else {
        errorMessage = e.toString();
      }

      emit(LoginFailure(error: errorMessage));
    }
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(LoginInitial());
  }
}

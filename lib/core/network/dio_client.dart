import 'package:dio/dio.dart';

import 'interceptors.dart';

class DioClient {
  late final Dio _dio;
  DioClient()
    : _dio = Dio(
        BaseOptions(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          },
          responseType: ResponseType.json,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          validateStatus: (status) {
            return status! < 500; // Consider anything below 500 as response
          },
        ),
      )..interceptors.addAll([LoggerInterceptor()]);

  // Helper method to handle DioExceptions
  String _handleDioError(DioException error) {
    String errorMessage = "An error occurred";

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = "Connection timed out";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Send timeout exceeded";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Receive timeout exceeded";
        break;
      case DioExceptionType.badCertificate:
        errorMessage = "Bad certificate";
        break;
      case DioExceptionType.badResponse:
        // Handle the validation error response
        if (error.response != null) {
          try {
            // Extract server message if available
            final data = error.response!.data;
            if (data is Map<String, dynamic>) {
              if (data.containsKey('message')) {
                errorMessage = data['message'].toString();
              } else if (data.containsKey('error')) {
                errorMessage = data['error'].toString();
              } else {
                errorMessage = "Server error: ${error.response!.statusCode}";
              }

              // Handle validation errors which often come as errors.field_name format
              if (data.containsKey('errors') && data['errors'] is Map) {
                final Map errors = data['errors'];
                final List<String> errorList = [];
                errors.forEach((key, value) {
                  if (value is List) {
                    errorList.add("$key: ${value.join(', ')}");
                  } else {
                    errorList.add("$key: $value");
                  }
                });
                if (errorList.isNotEmpty) {
                  errorMessage = "Validation errors:\n${errorList.join('\n')}";
                }
              }
            } else {
              errorMessage =
                  "Server returned status code: ${error.response!.statusCode}";
            }
          } catch (e) {
            errorMessage =
                "Error parsing response: ${error.response!.statusCode}";
          }
        } else {
          errorMessage = "Bad response, no details available";
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = "Request was cancelled";
        break;
      case DioExceptionType.connectionError:
        errorMessage =
            "Connection error - please check your internet connection";
        break;
      case DioExceptionType.unknown:
      default:
        if (error.message != null) {
          errorMessage = error.message!;
        }
        break;
    }

    return errorMessage;
  }

  // GET METHOD
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw "Unexpected error occurred: $e";
    }
  }

  // POST METHOD
  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw "Unexpected error occurred: $e";
    }
  }

  // PUT METHOD
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw "Unexpected error occurred: $e";
    }
  }

  // DELETE METHOD
  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw "Unexpected error occurred: $e";
    }
  }
}

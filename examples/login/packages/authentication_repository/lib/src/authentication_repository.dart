import 'package:dio/dio.dart';

class AuthenticationRepository {
  AuthenticationRepository();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'put the base Url for the API here',
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    ),
  )..interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));

  Future<Response> logIn({required String email, required String password}) {
    final params = <String, String>{};
    params['email'] = email;
    params['password'] = password;

    return _dio.post('login', data: params);
  }
}

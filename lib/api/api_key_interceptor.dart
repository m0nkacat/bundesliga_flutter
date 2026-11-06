import 'package:dio/dio.dart';

// Interceptor автоматически добавляет API-ключ в заголовок каждого запроса
class ApiKeyInterceptor extends Interceptor {
  ApiKeyInterceptor(this.apiKey);

  final String apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Api-Key'] = apiKey;
    handler.next(options);
  }
}

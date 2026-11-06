import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../api/api_key_interceptor.dart';
import '../api/football_api.dart';

// Контейнер зависимостей: создаём объекты в одном месте, экраны берут их отсюда
final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.api-ninjas.com/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.addAll([
      ApiKeyInterceptor(dotenv.env['API_KEY'] ?? ''),
      // Логи запросов в консоль; заголовки не печатаем, чтобы не светить ключ
      PrettyDioLogger(requestHeader: false, responseBody: false),
    ]);
    return dio;
  });

  getIt.registerLazySingleton<FootballApi>(() => FootballApi(getIt<Dio>()));
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Сообщение об ошибке с кнопкой повтора
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  String get _message {
    final e = error;
    if (e is DioException) {
      final code = e.response?.statusCode;
      if (code == 401 || code == 403) return 'Неверный API-ключ';
      if (code == 429) return 'Превышен лимит запросов';
      if (e.response == null) return 'Нет соединения с сервером';
      return 'Ошибка сервера ($code)';
    }
    return 'Что-то пошло не так';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(_message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Повторить')),
        ],
      ),
    );
  }
}

import 'package:dio/dio.dart';

import '../models/player.dart';
import '../models/standing.dart';

// Запросы к Football API (api-ninjas.com)
class FootballApi {
  FootballApi(this._dio);

  final Dio _dio;

  static const league = 'bundesliga';

  // Турнирная таблица Бундеслиги
  Future<List<Standing>> getStandings() async {
    final response = await _dio.get(
      '/soccerstandings',
      queryParameters: {'league': league},
    );
    final data = response.data as List;
    return data.map((json) => Standing.fromJson(json)).toList();
  }

  // Состав клуба по его id
  Future<List<Player>> getSquad(String teamId) async {
    final response = await _dio.get(
      '/soccerplayers',
      queryParameters: {'league': league, 'team': teamId},
    );
    final data = response.data as List;
    return data.map((json) => Player.fromJson(json)).toList();
  }
}

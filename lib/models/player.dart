// Игрок из состава клуба
class Player {
  final String id;
  final String name;
  final String position;
  final int? number;
  final int? heightCm;
  final int? weightKg;
  final String? birthDate;
  final String? nationality;

  Player({
    required this.id,
    required this.name,
    required this.position,
    this.number,
    this.heightCm,
    this.weightKg,
    this.birthDate,
    this.nationality,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['player_id'],
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      number: _toInt(json['jersey_number']),
      heightCm: _toInt(json['height_cm']),
      weightKg: _toInt(json['weight_kg']),
      birthDate: json['birth_date'],
      nationality: json['nationality'],
    );
  }

  // Позиция на русском
  String get positionName {
    switch (position) {
      case 'G':
        return 'Вратарь';
      case 'D':
        return 'Защитник';
      case 'M':
        return 'Полузащитник';
      case 'F':
        return 'Нападающий';
      default:
        return 'Не указана';
    }
  }

  // Название группы в составе (множественное число)
  String get positionGroup {
    switch (position) {
      case 'G':
        return 'Вратари';
      case 'D':
        return 'Защитники';
      case 'M':
        return 'Полузащитники';
      case 'F':
        return 'Нападающие';
      default:
        return 'Другие';
    }
  }

  // Числа в ответе могут прийти как int, double или строка
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.round();
    return int.tryParse(value.toString());
  }
}

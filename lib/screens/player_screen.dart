import 'package:flutter/material.dart';

import '../models/player.dart';

// Карточка игрока
class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key, required this.player});

  final Player player;

  // Возраст по дате рождения (формат YYYY-MM-DD)
  int? get _age {
    final birth = DateTime.tryParse(player.birthDate ?? '');
    if (birth == null) return null;
    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(player.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${player.number ?? '–'}',
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            player.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(player.positionName, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          _info('Гражданство', player.nationality),
          _info('Дата рождения', player.birthDate),
          _info('Возраст', _age?.toString()),
          _info(
            'Рост',
            player.heightCm != null ? '${player.heightCm} см' : null,
          ),
          _info(
            'Вес',
            player.weightKg != null ? '${player.weightKg} кг' : null,
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String? value) {
    return ListTile(
      title: Text(label),
      trailing: Text(value ?? '—', style: const TextStyle(fontSize: 16)),
    );
  }
}

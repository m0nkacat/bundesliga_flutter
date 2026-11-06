import 'package:flutter/material.dart';

import '../api/football_api.dart';
import '../di/locator.dart';
import '../models/player.dart';
import '../models/standing.dart';
import '../widgets/error_view.dart';
import 'player_screen.dart';

// Экран состава клуба, игроки сгруппированы по позициям
class SquadScreen extends StatefulWidget {
  const SquadScreen({super.key, required this.team});

  final Standing team;

  @override
  State<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends State<SquadScreen> {
  final _api = getIt<FootballApi>();
  late Future<List<Player>> _future;

  static const _positionOrder = ['G', 'D', 'M', 'F'];

  @override
  void initState() {
    super.initState();
    _future = _api.getSquad(widget.team.teamId);
  }

  void _reload() {
    setState(() {
      _future = _api.getSquad(widget.team.teamId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.team.teamName)),
      body: FutureBuilder<List<Player>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error, onRetry: _reload);
          }
          final players = snapshot.data!;
          if (players.isEmpty) {
            return const Center(child: Text('Состав не найден'));
          }

          // Сортируем: сначала по позиции, затем по номеру
          players.sort((a, b) {
            final byPos = _rank(a.position).compareTo(_rank(b.position));
            if (byPos != 0) return byPos;
            return (a.number ?? 99).compareTo(b.number ?? 99);
          });

          final children = <Widget>[_TeamSummary(team: widget.team)];
          String? lastPosition;
          for (final p in players) {
            if (p.position != lastPosition) {
              lastPosition = p.position;
              children.add(_SectionTitle(p.positionGroup));
            }
            children.add(
              ListTile(
                leading: CircleAvatar(child: Text('${p.number ?? '–'}')),
                title: Text(p.name),
                subtitle: Text(p.nationality ?? ''),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlayerScreen(player: p)),
                ),
              ),
            );
          }
          return ListView(children: children);
        },
      ),
    );
  }

  int _rank(String position) {
    final i = _positionOrder.indexOf(position);
    return i == -1 ? _positionOrder.length : i;
  }
}

// Краткая статистика команды над составом
class _TeamSummary extends StatelessWidget {
  const _TeamSummary({required this.team});

  final Standing team;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _stat('Место', '${team.rank}'),
            _stat('Очки', '${team.points}'),
            _stat('В-Н-П', '${team.wins}-${team.draws}-${team.losses}'),
            _stat('Голы', '${team.goalsFor}:${team.goalsAgainst}'),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

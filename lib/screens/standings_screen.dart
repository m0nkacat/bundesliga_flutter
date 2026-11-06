import 'package:flutter/material.dart';

import '../api/football_api.dart';
import '../di/locator.dart';
import '../models/standing.dart';
import '../widgets/error_view.dart';
import 'squad_screen.dart';

// Экран турнирной таблицы
class StandingsScreen extends StatefulWidget {
  const StandingsScreen({super.key});

  @override
  State<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  final _api = getIt<FootballApi>();
  late Future<List<Standing>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.getStandings();
  }

  void _reload() {
    setState(() {
      _future = _api.getStandings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Бундеслига')),
      body: FutureBuilder<List<Standing>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error, onRetry: _reload);
          }
          final table = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              _reload();
              await _future;
            },
            child: ListView(
              children: [
                const _HeaderRow(),
                for (final row in table) _StandingRow(row: row),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Заголовок таблицы
class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium;
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 28, child: Text('#', style: style)),
          Expanded(child: Text('Команда', style: style)),
          _cell('И', style),
          _cell('В', style),
          _cell('Н', style),
          _cell('П', style),
          _cell('РМ', style),
          _cell('О', style),
        ],
      ),
    );
  }
}

// Строка таблицы, по нажатию открывается состав
class _StandingRow extends StatelessWidget {
  const _StandingRow({required this.row});

  final Standing row;

  @override
  Widget build(BuildContext context) {
    final bold = const TextStyle(fontWeight: FontWeight.bold);
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SquadScreen(team: row)),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: _zoneColor(row.qualification), width: 4),
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 28, child: Text('${row.rank}')),
            Expanded(
              child: Text(row.teamName, overflow: TextOverflow.ellipsis),
            ),
            _cell('${row.played}'),
            _cell('${row.wins}'),
            _cell('${row.draws}'),
            _cell('${row.losses}'),
            _cell(
              row.goalDifference > 0
                  ? '+${row.goalDifference}'
                  : '${row.goalDifference}',
            ),
            _cell('${row.points}', bold),
          ],
        ),
      ),
    );
  }

  // Цвет полоски слева: еврокубки или вылет
  Color _zoneColor(String? qualification) {
    final q = (qualification ?? '').toLowerCase();
    if (q.contains('champions')) return Colors.blue;
    if (q.contains('europa') || q.contains('conference')) return Colors.orange;
    if (q.contains('relegation')) return Colors.red;
    return Colors.transparent;
  }
}

Widget _cell(String text, [TextStyle? style]) {
  return SizedBox(
    width: 30,
    child: Text(text, textAlign: TextAlign.center, style: style),
  );
}

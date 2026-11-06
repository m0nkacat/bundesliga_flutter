// Строка турнирной таблицы
class Standing {
  final int rank;
  final String teamId;
  final String teamName;
  final int played;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  final int points;
  final String? qualification;

  Standing({
    required this.rank,
    required this.teamId,
    required this.teamName,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    required this.points,
    this.qualification,
  });

  factory Standing.fromJson(Map<String, dynamic> json) {
    final team = json['team'] as Map<String, dynamic>;
    return Standing(
      rank: json['league_rank'] ?? 0,
      teamId: team['team_id'],
      teamName: team['name'],
      played: json['games_played'] ?? 0,
      wins: json['wins'] ?? 0,
      draws: json['draws'] ?? 0,
      losses: json['losses'] ?? 0,
      goalsFor: json['goals_for'] ?? 0,
      goalsAgainst: json['goals_against'] ?? 0,
      goalDifference: json['goal_difference'] ?? 0,
      points: json['points'] ?? 0,
      qualification: json['qualification'],
    );
  }
}

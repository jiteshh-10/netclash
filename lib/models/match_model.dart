class MatchModel {
  final String id;
  final String tournamentId;
  final String player1;
  final String player2;
  final int score1;
  final int score2;
  final bool isLive;

  MatchModel({
    required this.id,
    required this.tournamentId,
    required this.player1,
    required this.player2,
    required this.score1,
    required this.score2,
    required this.isLive,
  });

  factory MatchModel.fromMap(Map<String, dynamic> data, String id) {
    return MatchModel(
      id: id,
      tournamentId: data['tournamentId'] ?? '',
      player1: data['player1'] ?? '',
      player2: data['player2'] ?? '',
      score1: data['score1'] ?? 0,
      score2: data['score2'] ?? 0,
      isLive: data['isLive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tournamentId': tournamentId,
      'player1': player1,
      'player2': player2,
      'score1': score1,
      'score2': score2,
      'isLive': isLive,
    };
  }
}
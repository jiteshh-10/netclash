class TournamentModel {
  final String id;
  final String name;
  final String date;
  final List<String> participants;

  TournamentModel({
    required this.id,
    required this.name,
    required this.date,
    required this.participants,
  });

  factory TournamentModel.fromMap(Map<String, dynamic> data, String id) {
    return TournamentModel(
      id: id,
      name: data['name'] ?? '',
      date: data['date'] ?? '',
      participants: List<String>.from(data['participants'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'participants': participants,
    };
  }
}
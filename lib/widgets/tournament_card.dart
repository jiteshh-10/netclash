import 'package:flutter/material.dart';
import 'package:netclash/models/tournament_model.dart';

class TournamentCard extends StatelessWidget {
  final String name;
  final String date;
  final List<String> participants;

  const TournamentCard({
    required this.name,
    required this.date,
    required this.participants,
    super.key, required TournamentModel tournament,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Participants:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...participants.map(
              (participant) => Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: Text(
                  '- $participant',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
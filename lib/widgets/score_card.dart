import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final String player1;
  final String player2;
  final int score1;
  final int score2;
  final bool isLive;

  const ScoreCard({
    required this.player1,
    required this.player2,
    required this.score1,
    required this.score2,
    required this.isLive,
    super.key,
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
              'Match: $player1 vs $player2',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: $score1 - $score2',
              style: const TextStyle(fontSize: 14),
            ),
            if (isLive)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Status: Live',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
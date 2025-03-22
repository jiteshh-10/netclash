import 'package:flutter/material.dart';
import 'package:netclash/models/match_model.dart';
import 'package:netclash/utils/constants.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final bool isAdmin;
  final VoidCallback onEdit;

  const MatchCard({super.key, 
    required this.match,
    required this.isAdmin,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.padding, vertical: 8.0),
      child: ListTile(
        title: Text('${match.player1} vs ${match.player2}'),
        subtitle: Text('Score: ${match.score1} - ${match.score2}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (match.isLive)
              const Icon(Icons.live_tv, color: Colors.red),
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
          ],
        ),
      ),
    );
  }
}
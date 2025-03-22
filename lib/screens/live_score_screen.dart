import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:netclash/models/match_model.dart';
import 'package:netclash/services/auth_service.dart';
import 'package:netclash/services/firestore_service.dart';
import 'package:netclash/utils/constants.dart';

class LiveScoreScreen extends StatelessWidget {
  final String tournamentId;
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  LiveScoreScreen({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.currentUser,
      builder: (context, AsyncSnapshot userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor));
        }
        final isAdmin = userSnapshot.hasData && userSnapshot.data?.role == 'admin';

        return Scaffold(
          appBar: AppBar(title: const Text('Live Scores')),
          body: StreamBuilder<List<MatchModel>>(
            stream: _firestoreService.getMatches(tournamentId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No matches available.'));
              }

              final matches = snapshot.data!;
              return ListView.builder(
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  return ListTile(
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
                            onPressed: () {
                              // Show dialog to update score
                              _showUpdateScoreDialog(context, match);
                            },
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showUpdateScoreDialog(BuildContext context, MatchModel match) {
    final TextEditingController _score1Controller = TextEditingController(text: match.score1.toString());
    final TextEditingController _score2Controller = TextEditingController(text: match.score2.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Score'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _score1Controller,
                decoration: InputDecoration(labelText: '${match.player1} Score'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _score2Controller,
                decoration: InputDecoration(labelText: '${match.player2} Score'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final score1 = int.tryParse(_score1Controller.text) ?? 0;
                final score2 = int.tryParse(_score2Controller.text) ?? 0;
                await _firestoreService.updateMatchScore(match.id, score1, score2);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
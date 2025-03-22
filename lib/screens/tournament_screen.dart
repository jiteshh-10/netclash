import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:netclash/models/tournament_model.dart';
import 'package:netclash/services/firestore_service.dart';
import 'package:netclash/widgets/tournament_card.dart';
import 'package:netclash/utils/constants.dart';

class TournamentScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournaments')),
      body: StreamBuilder<List<TournamentModel>>(
        stream: _firestoreService.getTournaments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitFadingCircle(
                color: AppColors.primaryColor,
                size: 50.0,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tournaments available.'));
          }

          final tournaments = snapshot.data!;
          return ListView.builder(
            itemCount: tournaments.length,
            itemBuilder: (context, index) {
              return TournamentCard(tournament: tournaments[index], name: '', participants: const [], date: '',);
            },
          );
        },
      ),
    );
  }
}
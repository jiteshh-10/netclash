import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netclash/models/tournament_model.dart';
import 'package:netclash/models/match_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new tournament
  Future<void> createTournament(TournamentModel tournament) async {
    await _firestore.collection('tournaments').add(tournament.toMap());
  }

  // Get all tournaments
  Stream<List<TournamentModel>> getTournaments() {
    return _firestore.collection('tournaments').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TournamentModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get matches for a tournament
  Stream<List<MatchModel>> getMatches(String tournamentId) {
    return _firestore
        .collection('matches')
        .where('tournamentId', isEqualTo: tournamentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MatchModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Update match score
  Future<void> updateMatchScore(String matchId, int score1, int score2) async {
    await _firestore.collection('matches').doc(matchId).update({
      'score1': score1,
      'score2': score2,
    });
  }
}
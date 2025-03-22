import 'package:flutter/material.dart';
import 'package:netclash/models/tournament_model.dart' show TournamentModel;
import 'package:netclash/services/firestore_service.dart' show FirestoreService;
import 'package:netclash/utils/constants.dart' show AppSizes;
import 'package:netclash/widgets/custom_button.dart' show CustomButton;


class ManageTournamentScreen extends StatefulWidget {
  const ManageTournamentScreen({super.key});

  @override
  _ManageTournamentScreenState createState() => _ManageTournamentScreenState();
}

class _ManageTournamentScreenState extends State<ManageTournamentScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  bool _isLoading = false;

  void _createTournament() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final participants = _participantsController.text.split(',').map((e) => e.trim()).toList();
      final tournament = TournamentModel(
        id: '', // Will be set by Firestore
        name: _nameController.text,
        date: _dateController.text,
        participants: participants,
      );

      await _firestoreService.createTournament(tournament);

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Tournament')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tournament Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tournament name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.padding),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date (e.g., 2025-03-21)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Date is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.padding),
              TextFormField(
                controller: _participantsController,
                decoration: const InputDecoration(
                  labelText: 'Participants (comma-separated)',
                  hintText: 'Player1, Player2, Player3',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Participants are required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.padding),
              CustomButton(
                text: 'Create Tournament',
                onPressed: _createTournament,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
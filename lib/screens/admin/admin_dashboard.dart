import 'package:flutter/material.dart';
import 'package:netclash/services/auth_service.dart';
import 'package:netclash/screens/admin/manage_tournament_screen.dart';

class AdminDashboard extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.currentUser,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('User not found.'));
        }

        final user = snapshot.data!;
        if (user.role != 'admin') {
          return Scaffold(
            appBar: AppBar(title: const Text('Admin Dashboard')),
            body: const Center(child: Text('Access denied. Admins only.')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Admin Dashboard')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageTournamentScreen()),
                    );
                  },
                  child: const Text('Manage Tournaments'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
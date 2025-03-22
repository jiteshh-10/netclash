import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:netclash/screens/admin/admin_dashboard.dart';
import 'package:netclash/screens/auth/login_screen.dart' show LoginScreen;
import 'package:netclash/screens/profile_screen.dart' show ProfileScreen;
import 'package:netclash/screens/tournament_screen.dart' show TournamentScreen;
import 'package:netclash/services/auth_service.dart' show AuthService;
import 'package:netclash/utils/constants.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.currentUser,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return LoginScreen();
        }

        final user = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Badminton Score Tracker'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await _authService.signOut();
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: AppColors.primaryColor),
                  child: Text('Menu', style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  title: const Text('Tournaments'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TournamentScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
                if (user.role == 'admin')
                  ListTile(
                    title: const Text('Admin Dashboard'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminDashboard()),
                      );
                    },
                  ),
              ],
            ),
          ),
          body: const Center(
            child: Text('Welcome to Net-Clash!'),
          ),
        );
      },
    );
  }
}
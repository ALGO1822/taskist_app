
import 'package:flutter/material.dart';
import 'package:taskist_app/constants/app_theme.dart';
import 'package:taskist_app/model/user.dart';
import 'package:taskist_app/services/auth_service.dart';
import 'package:taskist_app/view/home_page.dart';

class UserSelectionPage extends StatefulWidget {
  const UserSelectionPage({super.key});

  @override
  State<UserSelectionPage> createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  final AuthService _authService = AuthService();
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = AuthService.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Select User'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(user.name, style: theme.textTheme.titleMedium),
                    subtitle: Text(user.email, style: theme.textTheme.bodyMedium),
                    onTap: () async {
                      await _authService.saveLoggedInUser(user.email);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage(userEmail: user.email)),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

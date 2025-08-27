
import 'package:flutter/material.dart';
import 'package:taskist_app/constants/app_theme.dart';
import 'package:taskist_app/services/auth_service.dart';
import 'package:taskist_app/view/auth_page.dart';
import 'package:taskist_app/view/home_page.dart';
import 'package:taskist_app/view/user_selection_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final loggedInUser = await _authService.getLoggedInUser();
    if (loggedInUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage(userEmail: loggedInUser)),
      );
    } else {
      final allUsers = await AuthService.getAllUsers();
      if (allUsers.isNotEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const UserSelectionPage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
        ),
      ),
    );
  }
}

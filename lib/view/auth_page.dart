import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskist_app/constants/app_theme.dart';
import 'package:taskist_app/providers/bottom_nav_provider.dart';
import 'package:taskist_app/view/login_page.dart';
import 'package:taskist_app/view/register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  final List<Widget> _pages = const [
    LoginPage(),
    RegisterPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navVM = context.watch<BottomNavProvider>();
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text(
          'Taskist App',
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 35),
        ),
      ),

      body: _pages[navVM.currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        iconSize: 30,
        selectedLabelStyle: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: theme.textTheme.bodyLarge,
        backgroundColor: theme.scaffoldBackgroundColor,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.unselectedWidgetColor,
        currentIndex: navVM.currentIndex,
        onTap: (index) => navVM.setIndex(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.login, size: 30,),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration, size: 30,),
            label: 'Register',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:taskist_app/constants/app_theme.dart';
import 'package:taskist_app/model/user.dart';
import 'package:taskist_app/services/auth_service.dart';
import 'package:taskist_app/view/auth_page.dart';
import 'package:taskist_app/view/project_page.dart';
import 'package:taskist_app/widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  final String userEmail;

  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authService = AuthService();
    final user = await authService.getCurrentUser(widget.userEmail);

    if (mounted) {
      setState(() {
        _user = user;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: () async {
            await AuthService.clearAllData();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuthPage()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('All data cleared')),
            );
          },
          child: Text(
            "Dashboard",
            style: theme.textTheme.titleLarge,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Text(
                    'Hello, ${_user?.name ?? 'User'} 👋',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome back! Here’s your task dashboard.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.unselectedWidgetColor,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Info Card
                  Card(
                    color: AppColors.backgroundColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: theme.primaryColor,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Profile Info',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildDetailRow(theme, 'Full Name', _user?.name),
                          const Divider(),
                          _buildDetailRow(theme, 'Email', _user?.email),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Create Project Button
                  CustomButton(
                    text: "Create Project",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProjectsScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Logout Button
                  CustomButton(
                    text: "Log out",
                    color: AppColors.errorRed,
                    onPressed: () async {
                      await AuthService().logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.mutedColor,
            ),
          ),
          Text(
            value ?? 'N/A',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


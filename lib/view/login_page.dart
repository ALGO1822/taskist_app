// /screens/login_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskist_app/constants/app_theme.dart';
import 'package:taskist_app/providers/login_provider.dart';
import 'package:taskist_app/view/home_page.dart';
import 'package:taskist_app/widgets/app_logo.dart';
import 'package:taskist_app/widgets/custom_button.dart';
import 'package:taskist_app/widgets/custom_textfield.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context, listen: true);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo
              const Center(
                child: AppLogo(),
              ),
              const SizedBox(height: 24),

              // Title
              Center(
                child: Text(
                  "Welcome Back",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "Login to continue using Taskist",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.mutedColor,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Email
              Text("Email", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: emailController,
                hintText: "Enter your email",
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password
              Text("Password", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: passwordController,
                hintText: "Enter your password",
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: theme.primaryColor,
                  ),
                  child: const Text("Forgot Password?"),
                ),
              ),

              const SizedBox(height: 16),

              // ERROR MESSAGE
              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    provider.error!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.errorRed),
                    textAlign: TextAlign.center,
                  ),
                ),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Login",
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text;

                          // Clear previous error
                          provider.clearError();

                          // Trigger login
                          final success = await provider.login(email, password);

                          if (success) {
                            // Optional: clear fields
                            emailController.clear();
                            passwordController.clear();

                            // Navigate to Home
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomePage(userEmail: email)),
                            );
                          }
                        },
                  isLoading: provider.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskist_app/constants/app_theme.dart';
import 'package:taskist_app/providers/register_provider.dart';
import 'package:taskist_app/view/login_page.dart';
import 'package:taskist_app/widgets/app_logo.dart';
import 'package:taskist_app/widgets/custom_button.dart';
import 'package:taskist_app/widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<RegisterProvider>(context, listen: true);

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
                  "Create Account",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "Register to get started with Taskist",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.mutedColor,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Full Name
              Text("Full Name", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: nameController,
                hintText: "Enter your full name",
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),

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
                hintText: "Create a password",
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
              const SizedBox(height: 20),

              // Confirm Password
              Text("Confirm Password", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: confirmPasswordController,
                hintText: "Re-enter your password",
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // ERROR MESSAGE (from Provider)
              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    provider.error!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.errorRed),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Register button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: provider.isLoading ? "" : "Register",
                  onPressed: provider.isLoading
                      ? () {}
                      : () async {
                          final name = nameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text;
                          final confirmPassword = confirmPasswordController.text;

                          // Clear previous error
                          provider.clearError();

                          // Validate confirm password
                          if (password != confirmPassword) {
                            provider.notifyError('Passwords do not match');
                            return;
                          }

                          // Trigger registration
                          final success = await provider.register(email, password, name);

                          if (success) {
                            // Optional: clear fields
                            nameController.clear();
                            emailController.clear();
                            passwordController.clear();
                            confirmPasswordController.clear();

                            // Navigate to Login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );

                            // Optional: show success snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Account created successfully!"),
                                backgroundColor: AppColors.successGreen,
                              ),
                            );
                          }
                        },
                  isLoading: provider.isLoading,
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

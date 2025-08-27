// /providers/register_provider.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ✅ New: Allows external classes to set an error (e.g., password mismatch)
  void notifyError(String message) {
    if (message.isEmpty) return;
    _error = message;
    _isLoading = false; // Always stop loading when setting external error
    notifyListeners();
  }

  // ✅ Updated: Now includes `name`
  Future<bool> register(String email, String password, String name) async {
    if (_isLoading) return false;

    // 🔍 Validate inputs
    if (name.isEmpty) {
      _error = 'Name is required';
      notifyListeners();
      return false;
    }

    if (email.isEmpty || !email.contains('@')) {
      _error = 'Please enter a valid email';
      notifyListeners();
      return false;
    }

    if (password.length <= 6) {
      _error = 'Password must be at least 7 characters';
      notifyListeners();
      return false;
    }

    // 🚀 Start loading
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _authService.register(email, password, name);

      if (success) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Email already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (_isLoading) return false;

    if (email.isEmpty || !email.contains('@')) {
      _error = 'Enter a valid email';
      notifyListeners();
      return false;
    }

    if (password.length <= 6) {
      _error = 'Password must be at least 7 characters';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _authService.login(email, password);

      if (success){
        _isLoading = false;
        await _authService.saveLoggedInUser(email);
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().contains('register')
          ? 'No account found. Please register first.'
          : 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
// /services/auth_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskist_app/model/user.dart';
import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart'; // ← Add this for Hive.deleteFromDisk()

class AuthService {
  static const String _usersKey = 'users_list';
  static const String _currentUserKey = 'current_user';

  Future<void> saveLoggedInUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, email);
  }

  Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  /// Registers a new user if email doesn't exist
  Future<bool> register(String email, String password, String name) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing users
    List<UserModel> users = [];
    final String? usersJson = prefs.getString(_usersKey);

    if (usersJson != null) {
      final List<dynamic> jsonList = jsonDecode(usersJson);
      users = jsonList.map((item) => UserModel.fromJson(item)).toList();
    }

    // Check for duplicate email
    final bool userExists = users.any((user) => user.email == email);
    if (userExists) {
      return false; // Email already taken
    }

    // Add new user
    users.add(UserModel(email: email, password: password, name: name));

    // Save back to SharedPreferences
    final List<Map<String, String>> usersMap = users
        .map((user) => user.toJson())
        .toList();
    final String updatedJson = json.encode(usersMap);
    await prefs.setString(_usersKey, updatedJson);

    return true; // Success
  }

  /// Logs in by checking email and password
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return false;

    try {
      final List<dynamic> jsonList = jsonDecode(usersJson);
      final List<UserModel> users = jsonList
          .map((item) => UserModel.fromJson(item))
          .toList();

      // Find matching user
      final user = users.firstWhereOrNull(
        (u) => u.email == email && u.password == password,
      );

      return user != null; // Return true if found
    } catch (e) {
      return false;
    }
  }

  /// Gets the full user data by email
  Future<UserModel?> getCurrentUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return null;

    try {
      final List<dynamic> jsonList = jsonDecode(usersJson);
      final List<UserModel> users = jsonList
          .map((item) => UserModel.fromJson(item))
          .toList();

      return users.firstWhereOrNull((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }

  /// Gets all registered users
  static Future<List<UserModel>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(usersJson);
      final List<UserModel> users = jsonList
          .map((item) => UserModel.fromJson(item))
          .toList();
      return users;
    } catch (e) {
      return [];
    }
  }

  static Future<void> clearAllData() async {
  await Hive.deleteFromDisk();
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
}

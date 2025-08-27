// models/user.dart

class UserModel {
  final String email;
  final String password;
  final String name; // ← new

  UserModel({required this.email, required this.password, required this.name});

  Map<String, String> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      name: json['name'],
    );
  }
}
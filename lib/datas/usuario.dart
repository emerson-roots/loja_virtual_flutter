import 'package:firebase_auth/firebase_auth.dart';

class Usuario {
  String? id;
  User? firebaseUser;
  final String email;
  final String password;
  final String name;
  final String address;

  Usuario({
    this.id,
    this.firebaseUser,
    required this.email,
    required this.password,
    required this.name,
    required this.address,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'address': address,
    };
  }

  factory Usuario.empty() {
    return Usuario(
      id: '',
      email: '',
      password: '',
      name: '',
      address: '',
    );
  }
}

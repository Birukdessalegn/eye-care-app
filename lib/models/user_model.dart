
import 'dart:convert';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? gender;
  final String? dateOfBirth;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.gender,
    this.dateOfBirth,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString() ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'], // Corrected syntax
      dateOfBirth: map['date_of_birth'], // Corrected syntax
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'gender': gender,
      'date_of_birth': dateOfBirth,
    };
  }

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

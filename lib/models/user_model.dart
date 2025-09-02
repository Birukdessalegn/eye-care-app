class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'user' or 'admin'

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: map['role'] ?? 'user',
    );
  }

  bool get isAdmin => role == 'admin';
}
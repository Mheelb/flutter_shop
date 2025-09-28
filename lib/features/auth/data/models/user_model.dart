import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final bool isEmailVerified;
  final String? createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.isEmailVerified,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      isEmailVerified: json['isEmailVerified'] as bool,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      isEmailVerified: user.isEmailVerified,
      createdAt: user.createdAt?.toIso8601String(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.isEmailVerified == isEmailVerified &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        isEmailVerified.hashCode ^
        (createdAt?.hashCode ?? 0);
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    bool? isEmailVerified,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, isEmailVerified: $isEmailVerified, createdAt: $createdAt)';
  }
}

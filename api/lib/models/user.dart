import 'dart:convert';

import 'package:postgres/postgres.dart';

enum RoleEnum { ADMIN, AUTHORITY, USER }

class UserModel {
  final String m_id;
  final String m_email;
  final String m_phone;
  final String m_username;
  final String m_name;
  final String m_password;
  final RoleEnum m_role;
  final DateTime m_createdAt;
  final DateTime m_updatedAt;
  final DateTime? m_deletedAt;

  UserModel({
    required String id,
    required String email,
    required String phone,
    required String username,
    required String name,
    required String password,
    required RoleEnum role,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : this.m_id = id,
       this.m_email = email,
       this.m_phone = phone,
       this.m_username = username,
       this.m_name = name,
       this.m_password = password,
       this.m_role = role,
       this.m_createdAt = createdAt,
       this.m_updatedAt = updatedAt,
       this.m_deletedAt = deletedAt;

  UserModel.FromDatabase(Map<String, dynamic> row)
    : this.m_id = row["id"] as String,
      this.m_email = row["email"] as String,
      this.m_phone = row["phone"] as String,
      this.m_username = row["username"] as String,
      this.m_name = row["name"] as String,
      this.m_password = row["password"] as String,
      this.m_role = RoleEnum.values.byName(
        utf8.decode((row["role"] as UndecodedBytes).bytes),
      ),
      this.m_createdAt = row["created_at"] as DateTime,
      this.m_updatedAt = row["updated_at"] as DateTime,
      this.m_deletedAt = row["deleted_at"] as DateTime?;

  Map<String, dynamic> UserResponse() {
    final response = {
      "id": this.m_id,
      "email": this.m_email,
      "phone": this.m_phone,
      "username": this.m_username,
      "name": this.m_name,
      "role": this.m_role.name,
      "createdAt": this.m_createdAt.toIso8601String(),
      "updatedAt": this.m_updatedAt.toIso8601String(),
      "deletedAt": this.m_deletedAt?.toIso8601String(),
    };

    return response;
  }
}

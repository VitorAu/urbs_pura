import 'dart:convert';

import 'package:postgres/postgres.dart';

enum RoleEnum { ADMIN, AUTHORITY, USER }

class UserModel {
  final String m_id;
  final String m_email;
  final String m_phone;
  final String m_username;
  final String m_name;
  final DateTime m_birthDate;
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
    required DateTime birthDate,
    required String password,
    required RoleEnum role,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : m_id = id,
       m_email = email,
       m_phone = phone,
       m_username = username,
       m_name = name,
       m_birthDate = birthDate,
       m_password = password,
       m_role = role,
       m_createdAt = createdAt,
       m_updatedAt = updatedAt,
       m_deletedAt = deletedAt;

  UserModel.FromDatabase(Map<String, dynamic> row)
    : m_id = row["id"] as String,
      m_email = row["email"] as String,
      m_phone = row["phone"] as String,
      m_username = row["username"] as String,
      m_name = row["name"] as String,
      m_birthDate = row["birth_date"] as DateTime,
      m_password = row["password"] as String,
      m_role = RoleEnum.values.byName(
        utf8.decode((row["role"] as UndecodedBytes).bytes),
      ),
      m_createdAt = row["created_at"] as DateTime,
      m_updatedAt = row["updated_at"] as DateTime,
      m_deletedAt = row["deleted_at"] as DateTime?;

  Map<String, dynamic> UserResponse() {
    final response = {
      "id": this.m_id,
      "email": this.m_email,
      "phone": this.m_phone,
      "username": this.m_username,
      "name": this.m_name,
      "birth_date": this.m_birthDate.toIso8601String(),
      "role": this.m_role.name,
      "createdAt": this.m_createdAt.toIso8601String(),
      "updatedAt": this.m_updatedAt.toIso8601String(),
      "deletedAt": this.m_deletedAt?.toIso8601String(),
    };

    return response;
  }
}

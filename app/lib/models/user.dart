enum RoleEnum { ADMIN, AUTHORITY, USER }

class UserModel {
  final String m_id;
  final String m_email;
  final String m_phone;
  final String m_username;
  final String m_name;
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
    required RoleEnum role,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : this.m_id = id,
       this.m_email = email,
       this.m_phone = phone,
       this.m_username = username,
       this.m_name = name,
       this.m_role = role,
       this.m_createdAt = createdAt,
       this.m_updatedAt = updatedAt,
       this.m_deletedAt = deletedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as String,
      email: json["email"] as String,
      phone: json["phone"] as String,
      username: json["username"] as String,
      name: json["name"] as String,
      role: RoleEnum.values.byName(json["role"] as String),
      createdAt: DateTime.parse(json["createdAt"] as String),
      updatedAt: DateTime.parse(json["updatedAt"] as String),
      deletedAt: json["deletedAt"] != null
          ? DateTime.parse(json["deletedAt"] as String)
          : null,
    );
  }
}

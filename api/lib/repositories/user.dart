import 'dart:convert';

import 'package:api/config/environment.dart';
import 'package:api/interfaces/user.dart';
import 'package:api/models/user.dart';
import 'package:api/services/auth.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:postgres/postgres.dart';

class UserRepository extends UserInterface {
  final Future<Connection> _m_connection;
  final AuthService _m_authService;
  UserRepository(Future<Connection> connection, AuthService authService)
    : _m_connection = connection,
      _m_authService = authService;

  @override
  Future<UserModel> CreateUser({
    required String email,
    required String phone,
    required String username,
    required String name,
    required DateTime birthDate,
    required String password,
  }) async {
    final connection = await this._m_connection;
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    final data = await connection.execute(
      Sql.named('''
        INSERT INTO users (
          email,
          phone,
          username,
          name,
          birth_date,
          password
        )
        VALUES (
          @email,
          @phone,
          @username,
          @name,
          @birth_date,
          @password
        )
        RETURNING *
      '''),
      parameters: {
        'email': email,
        'phone': phone,
        'username': username,
        'name': name,
        'birth_date': birthDate,
        'password': hashedPassword,
      },
    );

    if (data.isEmpty) throw new Exception("Failed to create user");
    final response = UserModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<String> CreateRefreshToken({
    required String id,
    required String email,
  }) async {
    final connection = await this._m_connection;
    final token = _m_authService.GenerateRefreshToken(id: id, email: email);
    final tokenHash = sha256.convert(utf8.encode(token)).toString();
    final expiresAt = DateTime.now().add(
      Duration(days: int.parse(Environment.ServerJwtRefreshTokenExpiration)),
    );

    await connection.execute(
      Sql.named('''
        INSERT INTO refresh_tokens (
          user_id,
          token,
          expires_at
        )
        VALUES (
          @user_id,
          @token,
          @expires_at
        )
      '''),
      parameters: {'user_id': id, 'token': tokenHash, 'expires_at': expiresAt},
    );

    return token;
  }

  @override
  Future<UserModel> GetUserById({required String id}) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM users
        WHERE id = @id
        AND deleted_at IS NULL
        LIMIT 1
      '''),
      parameters: {'id': id},
    );

    if (data.isEmpty) throw new Exception("Failed to find user");
    final response = UserModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<UserModel> GetUserByEmail({required String email}) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM users
        WHERE email = @email
        AND deleted_at IS NULL
        LIMIT 1
      '''),
      parameters: {'email': email},
    );

    if (data.isEmpty) throw new Exception("Failed to find user");
    final response = UserModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<UserModel> GetUserByRefreshToken({required String token}) async {
    final connection = await this._m_connection;
    final jwtToken = this._m_authService.VerifyToken(token);

    if (jwtToken == null || jwtToken.payload["type"] != "refresh") {
      throw Exception("Invalid refresh token");
    }

    final tokenHash = sha256.convert(utf8.encode(token)).toString();
    final tokenData = await connection.execute(
        Sql.named('''
          SELECT user_id FROM refresh_tokens
          WHERE token = @token
          AND expires_at > CURRENT_TIMESTAMP
          AND deleted_at IS NULL
          LIMIT 1
        '''),
        parameters: {
          'token': tokenHash
        }
      );

      if(tokenData.isEmpty) {
        throw Exception("Failed to find refresh token");
      }

      final id = tokenData.first.toColumnMap()['user_id'] as String;
      final userData = await this.GetUserById(id: id);
      return userData;
  }

  @override
  Future<UserModel> UpdateUser({
    required String id,
    String? email,
    String? phone,
    String? username,
    String? name,
    DateTime? birthDate,
  }) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        UPDATE users
        SET
        email = COALESCE(@email, email),
        phone = COALESCE(@phone, phone),
        username = COALESCE(@username, username),
        name = COALESCE(@name, name),
        birth_date = COALESCE(@birth_date, birth_date),
        updated_at = CURRENT_TIMESTAMP
        WHERE id = @id
        AND deleted_at IS NULL
        RETURNING *
      '''),
      parameters: {
        'id': id,
        'email': email,
        'phone': phone,
        'username': username,
        'name': name,
        'birth_date': birthDate,
      },
    );

    if (data.isEmpty) throw new Exception("Failed to update user");
    final response = UserModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<UserModel> UpdateUserPassword({
    required String id,
    required String password,
    required String newPassword,
  }) async {
    final connection = await this._m_connection;

    final verifyPassword = await this.VerifyUserPassword(
      id: id,
      password: password,
    );
    if (!verifyPassword) throw new Exception("Invalid credentials");

    final hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
    final data = await connection.execute(
      Sql.named('''
        UPDATE users
        SET
        password = @password,
        updated_at = CURRENT_TIMESTAMP
        WHERE id = @id
        AND deleted_at IS NULL
        RETURNING *
      '''),
      parameters: {'id': id, 'password': hashedPassword},
    );

    if (data.isEmpty) throw new Exception("Failed to update user password");
    final response = UserModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<bool> VerifyUserPassword({
    required String id,
    required String password,
  }) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT password FROM users
        WHERE id = @id
        AND deleted_at IS NULL
        LIMIT 1
      '''),
      parameters: {'id': id},
    );

    if (data.isEmpty) throw new Exception("Failed to find user");

    final passwordHash = data.first.toColumnMap()['password'] as String;
    final response = BCrypt.checkpw(password, passwordHash);
    return response;
  }

  @override
  Future<UserModel> DeleteUser({required String id}) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        UPDATE users
        SET
        updated_at = CURRENT_TIMESTAMP,
        deleted_at = CURRENT_TIMESTAMP
        WHERE id = @id
        AND deleted_at IS NULL
        RETURNING *
      '''),
      parameters: {'id': id},
    );

    if (data.isEmpty) throw new Exception("Failed to delete user");
    final response = UserModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<void> DeleteRefreshToken({required String token}) async {
    final connection = await this._m_connection;
    final jwtToken = this._m_authService.VerifyToken(token);

    if (jwtToken == null || jwtToken.payload["type"] != "refresh") {
      throw Exception("Invalid refresh token");
    }

    final tokenHash = sha256.convert(utf8.encode(token)).toString();
    await connection.execute(
      Sql.named('''
        UPDATE refresh_tokens
        SET
        deleted_at = CURRENT_TIMESTAMP
        WHERE token = @token
        AND deleted_at IS NULL
      '''),
      parameters: {
        'token': tokenHash
      }
    );
  }
}

import 'package:api/interfaces/user.dart';
import 'package:api/models/user.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:postgres/postgres.dart';

class UserRepository extends UserInterface {
  final Future<Connection> _m_connection;
  UserRepository(Future<Connection> connection) : _m_connection = connection;

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
          birth_date,
          password
        )
        VALUES (
          @email,
          @phone,
          @username,
          @birth_date,
          @password
        )
        RETURNING *
      '''),
      parameters: {
        'email': email,
        'phone': phone,
        'username': username,
        'birth_date': birthDate,
        'password': hashedPassword,
      },
    );

    if (data.isEmpty) throw new Exception("Failed to create user");
    final response = UserModel.FromDatabase(data.first.toColumnMap());
    return response;
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
        updated_at = CURRENT_TIMESTAMP
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
}

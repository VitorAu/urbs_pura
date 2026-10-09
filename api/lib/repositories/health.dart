import 'package:postgres/postgres.dart';

class HealthRepository {
  final Future<Connection> _m_connection;
  HealthRepository(Future<Connection> connection) : _m_connection = connection;

  Future<bool> GetDatabaseHealth() async {
    final connection = await this._m_connection;
    final response = await connection.execute('SELECT 1');

    if(response.isEmpty) return false;
    return true;
  }
}

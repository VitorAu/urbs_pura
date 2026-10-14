import 'dart:io';

import 'package:api/config/environment.dart';
import 'package:api/handlers/auth.dart';
import 'package:api/handlers/health.dart';
import 'package:api/repositories/health.dart';
import 'package:api/repositories/user.dart';
import 'package:api/services/auth.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

class Server {
  final Connection _m_connection;
  final Router _m_router = Router();

  Server(Connection connection): _m_connection = connection;

  Future<void> Start() async {
    final ip = InternetAddress.anyIPv4;

    final authService = AuthService();

    final healthRepository = HealthRepository(Future.value(this._m_connection));
    final userRepository  = UserRepository(Future.value(this._m_connection), authService);

    this._m_router.mount("/api/v1/health", HealthHandler(healthRepository).router);
    this._m_router.mount("/api/v1/auth", AuthHandler(userRepository, authService).router);

    final handler = Pipeline().addHandler(this._m_router.call);

    final port = int.parse(Environment.ServerPort);
    await serve(handler, ip, port);
  }
}

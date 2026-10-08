import 'dart:io';

import 'package:api/config/database.dart';
import 'package:api/config/environment.dart';
import 'package:api/server.dart';

void main() async {
  try {
    final database = await Database.GetDatabaseConnection();
    await Database.RunMigrations();
    final server = Server(database);
    server.Start();

    print("🚀 HTTP server running on http://localhost:${Environment.ServerPort}");
  } catch (err) {
    print("💥 Failed to start HTTP server: ${err.toString()}");
    await Database.Close();

    exit(1);
  }
}

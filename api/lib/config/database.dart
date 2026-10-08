import 'dart:io';
import 'dart:convert';

import 'package:api/config/environment.dart';
import 'package:postgres/postgres.dart';
import 'package:crypto/crypto.dart';

class Database {
  static Connection? _m_connection;

  static Future<void> _Connect() async {
    try {
      _m_connection = await Connection.open(
        Endpoint(
          host: Environment.DatabaseHost,
          port: int.parse(Environment.DatabasePort),
          database: Environment.DatabaseName,
          username: Environment.DatabaseUser,
          password: Environment.DatabasePassword,
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );

      print("✅ Successfully conected to database at:");
      print("• Database host: ${Environment.DatabaseHost.toString()}");
      print("• Database port: ${Environment.DatabasePort.toString()}");
      print("• Database name: ${Environment.DatabaseName.toString()}");
    } catch (err) {
      print("❌ Failed to connect to database: ${err.toString()}");
      rethrow;
    }
  }

  static Future<Connection> GetDatabaseConnection() async {
    if (_m_connection == null || !_m_connection!.isOpen) await _Connect();
    return _m_connection!;
  }

  static Future<void> Close() async {
    try {
      await _m_connection!.close();
      _m_connection = null;
      print("✅ Successfully closed the database");
    } catch (err) {
      print("❌ Failed to close the database: ${err.toString()}");
    }
  }

  static Future<void> RunMigrations() async {
    try {
      await _m_connection!.execute('''
      CREATE TABLE IF NOT EXISTS migrations(
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- [0]
        file_name VARCHAR(255) UNIQUE NOT NULL, -- [1]
        file_hash VARCHAR(32) NOT NULL, -- [2]
        created_at TIMESTAMP DEFAULT now() -- [3]
      );
      ''');
      final migrations = await _m_connection!.execute(
        'SELECT * FROM migrations',
      );
      final migrationsDir = Directory("lib/config/migrations");
      final files = migrationsDir
          .listSync()
          .whereType<File>()
          .where((aux) => aux.path.endsWith(".sql"))
          .toList();
      files.sort((a, b) => a.path.compareTo(b.path));

      for (final file in files) {
        final fileName = file.path.split("/").last;
        final fileSql = await file.readAsString();
        final fileHash = md5.convert(utf8.encode(fileSql));
        final fileQueries = fileSql
            .split(";")
            .map((aux) => aux.trim())
            .where((aux) => aux.isNotEmpty);

        final migration = migrations.where((aux) => aux[1] == fileName).toList();
        if (migration.isNotEmpty) {
          if (migration[0][2] != fileHash.toString() ) {
            print("⚠️ Migration modified after being applied: $fileName");
          } else {
            print("⏭️ Migration already applied: $fileName");
          }

          continue;
        }

        print("⚙️ Running migration: $fileName");
        await _m_connection!.runTx((tx) async {
          for (final query in fileQueries) {
            print("📝 Executing: $query");
            await tx.execute(query);
          }

          await tx.execute(
            Sql.named('''
              INSERT INTO migrations (file_name, file_hash)
              VALUES(@file_name, @file_hash)
            '''),
            parameters: {
              'file_name': fileName,
              'file_hash': fileHash.toString(),
            },
          );
        });

        print("✅ Migration applied successfully: $fileName");
      }
    } catch (err) {
      print("❌ Failed to run migrations: ${err.toString()}");
      rethrow;
    }
  }
}

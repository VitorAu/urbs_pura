import "dart:io";

class Environment {
  static final _m_dartEnv = Platform.environment["DART_ENV"];
  static final _m_databasePort = Platform.environment["DATABASE_PORT"];
  static final _m_databaseHost = Platform.environment["DATABASE_HOST"];
  static final _m_databaseName = Platform.environment["DATABASE_NAME"];
  static final _m_databaseUser = Platform.environment["DATABASE_USER"];
  static final _m_databasePassword = Platform.environment["DATABASE_PASSWORD"];
  static final _m_databaseUrl = Platform.environment["DATABASE_URL"];
  static final _m_serverPort = Platform.environment["SERVER_PORT"];
  static final _m_serverJwtSecret = Platform.environment["SERVER_JWT_SECRET"];

  static String get DartEnv => _m_dartEnv ?? "development";
  static String get DatabasePort => _m_databasePort ?? "5432";
  static String get DatabaseHost => _m_databaseHost ?? "localhost";
  static String get DatabaseName => _m_databaseName ?? "urbs_pura_db_dev";
  static String get DatabaseUser => _m_databaseUser ?? "urbs_pura_user_dev";
  static String get DatabasePassword => _m_databasePassword ?? "";
  static String get DatabaseUrl => _m_databaseUrl ?? "";
  static String get ServerPort => _m_serverPort ?? "8080";
  static String get ServerJwtSecret => _m_serverJwtSecret ?? "";
}

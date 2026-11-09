import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static final _m_apiUrl = dotenv.get("API_URL");

  static String get ApiUrl => _m_apiUrl;
}

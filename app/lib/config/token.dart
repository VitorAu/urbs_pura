
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token {
  static const FlutterSecureStorage m_storage =
      FlutterSecureStorage();

  static const String m_accessTokenKey = 'access_token';
  static const String m_refreshTokenKey = 'refresh_token';

  static Future<void> Save({
    required String accessToken,
    required String refreshToken,
  }) async {
    await m_storage.write(
      key: m_accessTokenKey,
      value: accessToken,
    );

    await m_storage.write(
      key: m_refreshTokenKey,
      value: refreshToken,
    );
  }

  static Future<String?> GetAccessToken() async {
    return await m_storage.read(key: m_accessTokenKey);
  }

  static Future<String?> GetRefreshToken() async {
    return await m_storage.read(key: m_refreshTokenKey);
  }

  static Future<void> Delete() async {
    await m_storage.delete(key: m_accessTokenKey);
    await m_storage.delete(key: m_refreshTokenKey);
  }
}

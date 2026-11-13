import 'package:api/config/environment.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService {
  String GenerateAccessToken({required String id, required String email}) {
    final accessToken = JWT({'sub': id, 'email': email, 'type': "access"});

    final aux = accessToken.sign(
      SecretKey(Environment.ServerJwtSecret),
      expiresIn: Duration(
        hours: int.parse(Environment.ServerJwtAccessTokenExpiration),
      ),
    );
    return aux;
  }

  String GenerateRefreshToken({required String id, required String email}) {
    final refreshToken = JWT({'sub': id, 'email': email, 'type': "refresh"});

    final aux = refreshToken.sign(
      SecretKey(Environment.ServerJwtSecret),
      expiresIn: Duration(
        days: int.parse(Environment.ServerJwtRefreshTokenExpiration),
      ),
    );
    return aux;
  }

  JWT? VerifyToken(String token) {
    try {
      final aux = JWT.verify(token, SecretKey(Environment.ServerJwtSecret));
      return aux;
    } catch (_) {
      return null;
    }
  }
}

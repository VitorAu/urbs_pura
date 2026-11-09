
import 'package:app/models/user.dart';

class AuthModel {
  final UserModel m_user;
  final String m_accessToken;
  final String m_refreshToken;

  AuthModel({
    required UserModel user,
    required String accessToken,
    required String refreshToken,
  }) : m_user = user,
       m_accessToken = accessToken,
       m_refreshToken = refreshToken;

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: UserModel.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

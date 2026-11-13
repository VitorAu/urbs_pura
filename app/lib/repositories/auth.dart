
import 'package:app/config/api.dart';
import 'package:app/interfaces/auth.dart';
import 'package:app/models/auth.dart';
import 'package:app/models/user.dart';

class AuthRepository implements AuthInterface {
  final Api m_api = Api();

  @override
  Future<dynamic> Register({
    required String email,
    required String phone,
    required String username,
    required String name,
    required String password,
  }) {
    return m_api.Request<UserModel>(
      method: 'POST',
      endpoint: '/auth/register',
      body: {
        'email': email,
        'phone': phone,
        'username': username,
        'name': name,
        'password': password,
      },
      fromJson: (data) => UserModel.fromJson(data),
    );
  }

  @override
  Future<dynamic> Login({
    required String email,
    required String password,
  }) {
    return m_api.Request<AuthModel>(
      method: 'POST',
      endpoint: '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
      fromJson: (data) => AuthModel.fromJson(data),
    );
  }

  @override
  Future<dynamic> Refresh({required String refreshToken}) {
    return m_api.Request<AuthModel>(
      method: 'POST',
      endpoint: '/auth/refresh',
      body: {'refreshToken': refreshToken},
      // Refresh has no refreshToken in its response.
    );
  }

  @override
  Future<dynamic> Logout({
    required String refreshToken,
    String? accessToken,
  }) {
    return m_api.Request<void>(
      method: 'POST',
      endpoint: '/auth/logout',
      body: {'refreshToken': refreshToken},
    );
  }
}

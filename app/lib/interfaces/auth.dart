abstract class AuthInterface {
  Future<dynamic> Login({required String email,
    required String password});
  Future<dynamic> Register({
    required String email,
    required String phone,
    required String username,
    required String name,
    required String password,
  });
  Future<dynamic> Logout({
    required String refreshToken,
    String? accessToken,
  });
  Future<dynamic> Refresh({
    required String refreshToken,
  });
}

import 'package:api/models/user.dart';

abstract class UserInterface {
  Future<UserModel> CreateUser({
    required String email,
    required String phone,
    required String username,
    required String name,
    required String password,
  });
  Future<String> CreateRefreshToken({
    required String id,
    required String email
  });
  Future<UserModel> GetUserById({required String id});
  Future<UserModel> GetUserByEmail({required String email});
  Future<UserModel> GetUserByRefreshToken({required String token});
  Future<UserModel> UpdateUser({
    required String id,
    String? email,
    String? phone,
    String? username,
    String? name,
  });
  Future<UserModel> UpdateUserPassword({
    required String id,
    required String password,
    required String newPassword,
  });
  Future<bool> VerifyUserPassword({
    required String id,
    required String password,
  });
  Future<UserModel> DeleteUser({required String id});
  Future<void> DeleteRefreshToken({required String token});
}

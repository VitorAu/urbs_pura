import 'package:api/models/user.dart';

abstract class UserInterface {
  Future<UserModel> CreateUser({
    required String email,
    required String phone,
    required String username,
    required String name,
    required DateTime birthDate,
    required String password,
  });
  Future<UserModel> GetUserById({required String id});
  Future<UserModel> GetUserByEmail({required String email});
  Future<UserModel> UpdateUser({
    required String id,
    String? email,
    String? phone,
    String? username,
    String? name,
    DateTime? birthDate,
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
}

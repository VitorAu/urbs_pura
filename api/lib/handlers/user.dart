import 'dart:convert';

import 'package:api/handlers/responses/error.dart';
import 'package:api/handlers/responses/success.dart';
import 'package:api/repositories/user.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UserHandler {
  final UserRepository _m_userRepository;

  UserHandler(UserRepository userRepository)
    : _m_userRepository = userRepository;

  Router get router {
    final router = Router();

    router.get('/<id>', this._GetUserById);
    router.get('/email/<email>', this._GetUserByEmail);
    router.patch('/<id>', this._UpdateUser);
    router.patch('/<id>/password', this._UpdateUserPassword);
    router.delete('/<id>', this._Delete);

    return router;
  }

  Future<Response> _GetUserById(Request request) async {
    try {
      final id = request.params['id']!;
      final getUserByIdResponse = await this._m_userRepository.GetUserById(
        id: id,
      );

      final response = Response(
        200,
        body: jsonEncode(
          SuccessResponse.Response(
            message: "User found successfully",
            data: getUserByIdResponse.UserResponse(),
          ),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: jsonEncode(
          ErrorResponse.Response(
            message: "Failed to find user",
            error: err.toString(),
          ),
        ),
      );
      return response;
    }
  }

   Future<Response> _GetUserByEmail(Request request) async {
    try {
      final email = request.params['email']!;
      final getUserByEmailResponse = await this._m_userRepository.GetUserByEmail(
        email: email,
      );

      final response = Response(
        200,
        body: jsonEncode(
          SuccessResponse.Response(
            message: "User found successfully",
            data: getUserByEmailResponse.UserResponse(),
          ),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: jsonEncode(
          ErrorResponse.Response(
            message: "Failed to find user",
            error: err.toString(),
          ),
        ),
      );
      return response;
    }
  }
  
  Future<Response> _UpdateUser(Request request) async {
    try {
      final data =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final id = request.params['id']!;
      final email = data['email'] as String?;
      final phone = data['phone'] as String?;
      final username = data['username'] as String?;
      final name = data['name'] as String?;
      final updateUserResponse = await this._m_userRepository.UpdateUser(
        id: id,
        email: email,
        phone: phone,
        username: username,
        name: name,
      );

      final response = Response(
        200,
        body: jsonEncode(
          SuccessResponse.Response(
            message: "User updated successfully",
            data: updateUserResponse.UserResponse(),
          ),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: jsonEncode(
          ErrorResponse.Response(
            message: "Failed to update user",
            error: err.toString(),
          ),
        ),
      );
      return response;
    }
  }
  
  Future<Response> _UpdateUserPassword(Request request) async {
    try {
      final data =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final id = request.params['id']!;
      final password = data['password'] as String;
      final newPassword = data['newPassword'] as String;
      final updateUserPasswordResponse = await this._m_userRepository.UpdateUserPassword(
        id: id,
        password: password,
        newPassword: newPassword
      );

      final response = Response(
        200,
        body: jsonEncode(
          SuccessResponse.Response(
            message: "User password updated successfully",
            data: updateUserPasswordResponse.UserResponse(),
          ),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: jsonEncode(
          ErrorResponse.Response(
            message: "Failed to update user password",
            error: err.toString(),
          ),
        ),
      );
      return response;
    }
  }
  
  Future<Response> _Delete(Request request) async {
    try {
      final id = request.params['id']!;
      final deleteResponse = await this._m_userRepository.DeleteUser(
        id: id,
      );

      final response = Response(
        200,
        body: jsonEncode(
          SuccessResponse.Response(
            message: "User deleted successfully",
            data: deleteResponse.UserResponse(),
          ),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: jsonEncode(
          ErrorResponse.Response(
            message: "Failed to delete user",
            error: err.toString(),
          ),
        ),
      );
      return response;
    }
  }
}

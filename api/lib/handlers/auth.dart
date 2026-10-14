import 'dart:convert';

import 'package:api/handlers/responses/error.dart';
import 'package:api/handlers/responses/success.dart';
import 'package:api/repositories/user.dart';
import 'package:api/services/auth.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthHandler {
  final UserRepository _m_userRepository;
  final AuthService _m_authService;

  AuthHandler(UserRepository userRepository, AuthService authService)
    : _m_userRepository = userRepository,
      _m_authService = authService;

  Router get router {
    final router = Router();
    router.post('/register', this._Register);
    router.post('/login', this._Login);
    router.post('/logout', this._Logout);
    router.post('/refresh', this._Refresh);
    return router;
  }

  Future<Response> _Register(Request request) async {
    try {
      final data =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final email = data['email'] as String;
      final phone = data['phone'] as String;
      final username = data['username'] as String;
      final name = data['name'] as String;
      final birthDate = DateTime.parse(data['birthDate'] as String);
      final password = data['password'] as String;
      final createUserResponse = await this._m_userRepository.CreateUser(
        email: email,
        phone: phone,
        username: username,
        name: name,
        birthDate: birthDate,
        password: password,
      );

      final response = Response(
        200,
        body: jsonEncode(
          SuccessResponse.Response(
            message: "User created successfully",
            data: createUserResponse.UserResponse(),
          ),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: jsonEncode(
          ErrorResponse.Response(
            message: "Failed to create user",
            error: err.toString(),
          ),
        ),
      );
      return response;
    }
  }

  Future<Response> _Login(Request request) async {
    try {
      final data =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final email = data['email'] as String;
      final password = data['password'] as String;
      final getUserByEmailData = await this._m_userRepository.GetUserByEmail(
        email: email,
      );
      final verifyUserPasswordData = await this._m_userRepository
          .VerifyUserPassword(id: getUserByEmailData.m_id, password: password);
      if (!verifyUserPasswordData) {
        final response = Response.internalServerError(
          body: jsonEncode(
            ErrorResponse.Response(
              message: "Failed to login into user",
              error: "Incorrect credentials",
            ),
          ),
        );
        return response;
      }
      final accessToken = this._m_authService.GenerateAccessToken(
        id: getUserByEmailData.m_id,
        email: getUserByEmailData.m_email,
      );
      final refreshToken = await this._m_userRepository.CreateRefreshToken(
        id: getUserByEmailData.m_id,
        email: getUserByEmailData.m_email,
      );

      final response = Response(
        200,
        body: jsonEncode(
          SuccessResponse.Response(
            message: "User created successfully",
            data: {
              'user': getUserByEmailData.UserResponse(),
              'accessToken': accessToken,
              'refreshToken': refreshToken,
            },
          ),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: jsonEncode(
          ErrorResponse.Response(
            message: "Failed to login into user",
            error: err.toString(),
          ),
        ),
      );
      return response;
    }
  }

  Future<Response> _Logout(Request request) async {
    try {
      final data =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final refreshToken = data['refreshToken'] as String;
      await this._m_userRepository.DeleteRefreshToken(token: refreshToken);

      final response = Response(
        200,
        body: jsonEncode(
          SuccessResponse.ResponseNoData(
            message: "User loged out successfully",
          ),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: jsonEncode(
          ErrorResponse.Response(
            message: "Failed to logout user",
            error: err.toString(),
          ),
        ),
      );
      return response;
    }
  }

  Future<Response> _Refresh(Request request) async {
    try {
      final data =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final refreshToken = data['refreshToken'] as String;
      final getUserByRefreshTokenData = await this._m_userRepository
          .GetUserByRefreshToken(token: refreshToken);
      final accessToken = this._m_authService.GenerateAccessToken(
        id: getUserByRefreshTokenData.m_id,
        email: getUserByRefreshTokenData.m_email,
      );

      final response = Response(
        200,
        body: jsonEncode(
          SuccessResponse.Response(
            message: "Access token refreshed",
            data: {
              'user': getUserByRefreshTokenData.UserResponse(),
              'accessToken': accessToken,
            },
          ),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: jsonEncode(
          ErrorResponse.Response(
            message: "Failed to refresh access token",
            error: err.toString(),
          ),
        ),
      );
      return response;
    }
  }
}

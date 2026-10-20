import 'dart:convert';

import 'package:api/handlers/responses/error.dart';
import 'package:api/services/auth.dart';
import 'package:shelf/shelf.dart';

class AuthMiddleware {
  static Middleware Auth(AuthService authService) {
    return (Handler innerHandler) {
      return (Request request) async {
        final authHeader = request.headers["authorization"];

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
          final response = Response(
            401,
            body: jsonEncode(
              ErrorResponse.Response(
                message: "Authentication failed",
                error: "Invalid authorization header",
              ),
            ),
            headers: {'content-type': 'application/json'},
          );
          return response;
        }

        final token = authHeader.substring(7);
        final jwt = authService.VerifyToken(token);

        if(jwt == null || jwt.payload["type"] != "access") {
          final response = Response(
            401,
            body: jsonEncode(
              ErrorResponse.Response(
                message: "Authentication failed",
                error: "Invalid or expired token",
              ),
            ),
            headers: {'content-type': 'application/json'},
          );
          return response;
        }

        final updatedRequest = request.change(
          context: {
            ...request.context,
            'userId': jwt.payload['sub'] as String,
            'userEmail': jwt.payload['email'] as String,
          },
        );

        return innerHandler(updatedRequest);
      };
    };
  }
}

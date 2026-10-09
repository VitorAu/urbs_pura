import 'dart:convert';

class ErrorResponse {
  static String Response({required String message, required String error}) {
    final response = jsonEncode({
      "status": "SUCCESS",
      "message": message,
      "error": error,
    });
    return response;
  }
}

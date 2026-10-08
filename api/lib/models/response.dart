import 'dart:convert';

class ResponseModel {
  static String SuccessResponse<T>({
    required String message,
    required T data,
  }) {
    final response = jsonEncode({
      "status": "SUCCESS",
      "message": message,
      "data": data,
    });
    return response;
  }

  static String SuccessNoDataResponse({
    required String message,
  }) {
    final response = jsonEncode({
      "status": "SUCCESS",
      "message": message,
    });
    return response;
  }

  static String ErrorResponse({
    required String message,
    required String error,
  }) {
    final response = jsonEncode({
      "status": "SUCCESS",
      "message": message,
      "error": error
    });
    return response;
  }
}

import 'dart:convert';

class SuccessResponse {
  static Response<T>({required String message, required T data}) {
    final response = jsonEncode({
      "status": "SUCCESS",
      "message": message,
      "data": data,
    });
    return response;
  }

  static ResponseNoData({required String message}) {
    final response = jsonEncode({"status": "SUCCESS", "message": message});
    return response;
  }
}


class ErrorResponseModel {
  final String m_status;
  final String m_message;
  final String m_error;

  ErrorResponseModel({
    required String status,
    required String message,
    required String error,
  }) : m_status = status,
       m_message = message,
       m_error = error;

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ErrorResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      error: json['error'] as String,
    );
  }
}

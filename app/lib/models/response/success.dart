
class SuccessResponseModel<T> {
  final String m_status;
  final String m_message;
  final T? m_data;

  SuccessResponseModel({
    required String status,
    required String message,
    T? data,
  }) : m_status = status,
       m_message = message,
       m_data = data;

  factory SuccessResponseModel.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromJson,
  }) {
    return SuccessResponseModel<T>(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : null,
    );
  }
}

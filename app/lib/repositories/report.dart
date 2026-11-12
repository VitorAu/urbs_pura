
import 'package:app/config/api.dart';
import 'package:app/models/response/error.dart';
import 'package:app/models/response/success.dart';

class ReportRepository {
  final Api _api = Api();

  Future<dynamic> createReport({
    required String categoryId,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    final response = await _api.Request<Map<String, dynamic>>(
      method: 'POST',
      endpoint: '/report/',
      body: {
        'report_category_id': categoryId,
        'description': description,
        'coordinates': {
          'latitude': latitude,
          'longitude': longitude,
        },
      },
      fromJson: (data) =>
          Map<String, dynamic>.from(data as Map),
    );

    if (response is SuccessResponseModel<Map<String, dynamic>> ||
        response is ErrorResponseModel) {
      return response;
    }

    throw Exception('Resposta inesperada ao criar denúncia.');
  }
}

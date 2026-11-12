import 'package:app/config/api.dart';
import 'package:app/models/response/error.dart';
import 'package:app/models/response/success.dart';

import 'dart:io';

import 'package:dio/dio.dart';

class ReportMediaRepository {
  final Api _api = Api();

  Future<dynamic> createReportMedia({required String reportId}) async {
    final response = await _api.Request<Map<String, dynamic>>(
      method: 'POST',
      endpoint: '/report_media/',
      body: {'report_id': reportId, 'sort_order': 0},
      fromJson: (data) => Map<String, dynamic>.from(data as Map),
    );

    if (response is SuccessResponseModel<Map<String, dynamic>> ||
        response is ErrorResponseModel) {
      return response;
    }

    throw Exception('Resposta inesperada ao registrar fotografia.');
  }

  Future<void> uploadImage({
    required String uploadUrl,
    required String imagePath,
  }) async {
    final file = File(imagePath);

    if (!await file.exists()) {
      throw Exception('Fotografia não encontrada no dispositivo.');
    }

    final dio = Dio();

    try {
      await dio.put<void>(
        uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            'Content-Type': 'image/jpeg',
            'Content-Length': await file.length(),
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
    } on DioException catch (error) {
      print('UPLOAD STATUS: ${error.response?.statusCode}');
      print('UPLOAD RESPONSE: ${error.response?.data}');
      rethrow;
    }
  }

  Future<dynamic> getReportMediasByReportId({required String reportId}) async {
    final response = await _api.Request<List<Map<String, dynamic>>>(
      method: 'GET',
      endpoint: '/report_media/report/$reportId',
      fromJson: (data) => (data as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(),
    );

    if (response is SuccessResponseModel<List<Map<String, dynamic>>> ||
        response is ErrorResponseModel) {
      return response;
    }

    throw Exception('Resposta inesperada ao buscar fotografias.');
  }
}

import 'dart:convert';

import 'package:api/models/responses/error.dart';
import 'package:api/models/responses/success.dart';
import 'package:api/repositories/report_media.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ReportMediaHandler {
  final ReportMediaRepository _m_reportMediaRepository;

  ReportMediaHandler(ReportMediaRepository reportMediaRepository)
    : _m_reportMediaRepository = reportMediaRepository;

  Router get router {
    final router = Router();

    router.post('/', this._CreateReportMedia);
    router.get('/<id>', this._GetReportMediaById);
    router.get('/report/<report_id>', this._GetReportMediaByReportId);
    // router.patch('/', this._UpdateReportMedia);
    // router.delete('/', this._DeleteReportMedia);

    return router;
  }

  Future<Response> _CreateReportMedia(Request request) async {
    try {
      final data =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final reportId = data['report_id'] as String;
      final sortOrder = data['sort_order'] as int;
      final createReportMediaResponse = await this._m_reportMediaRepository
          .CreateReportMedia(reportId: reportId, sortOrder: sortOrder);

      final response = Response(
        200,
        body: SuccessResponseModel.Response(
          message: "Report media created successfully",
          data: {
            ...createReportMediaResponse.model.ReportMediaResponse(),
            'upload_url': createReportMediaResponse.uploadUrl.toString(),
          },
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "Failed to create report media",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _GetReportMediaById(Request request) async {
    try {
      final id = request.params['id']!;
      final getReportMediaByIdResponse = await this._m_reportMediaRepository
          .GetReportMediaById(id: id);

      final response = Response(
        200,
        body: SuccessResponseModel.Response(
          message: "Report media found successfully",
          data: {
            ...getReportMediaByIdResponse.model.ReportMediaResponse(),
            'download_url': getReportMediaByIdResponse.downloadUrl.toString(),
          },
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "Failed to find report media",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _GetReportMediaByReportId(Request request) async {
    try {
      final reportId = request.params['report_id']!;
      final getReportMediasByReportIdResponse = await this
          ._m_reportMediaRepository
          .GetReportMediasByReportId(reportId: reportId);

      final response = Response(
        200,
        body: SuccessResponseModel.Response(
          message: "Report medias found successfully",
          data: getReportMediasByReportIdResponse.map((aux) {
            return {
              ...aux.model.ReportMediaResponse(),
              'download_url': aux.downloadUrl.toString(),
            };
          }).toList(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "Failed to find report medias",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }
}

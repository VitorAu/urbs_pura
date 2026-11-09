import 'dart:convert';

import 'package:api/models/responses/error.dart';
import 'package:api/models/responses/success.dart';
import 'package:api/repositories/report.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ReportHandler {
  final ReportRepository _m_reportRepository;

  ReportHandler(ReportRepository reportRepository)
    : _m_reportRepository = reportRepository;

  Router get router {
    final router = Router();

    router.post('/', this._CreateReport);
    router.get('/', this._GetReports);
    router.get('/<id>', this._GetReportById);
    router.get('/user/<user_id>', this._GetReportsByUserId);
    router.get(
      '/report_category/<report_category_id>',
      this._GetReportsByReportCategoryId,
    );
    router.patch('/<id>', this._UpdateReport);
    router.delete('/<id>', this._DeleteReport);

    return router;
  }

  Future<Response> _CreateReport(Request request) async {
    try {
      final data =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final userId = request.context['userId'] as String;
      final reportCategoryId = data['report_category_id'] as String;
      final description = data['description'] as String?;
      final street = data['street'] as String?;
      final number = data['number'] as String?;
      final complement = data['complement'] as String?;
      final neighborhood = data['neighborhood'] as String?;
      final city = data['city'] as String?;
      final state = data['state'] as String?;
      final postalCode = data['postal_code'] as String?;
      final coordinates = (
        longitude: (data['coordinates']['longitude'] as num).toDouble(),
        latitude: (data['coordinates']['latitude'] as num).toDouble(),
      );

      final createReportResponse = await this._m_reportRepository.CreateReport(
        userId: userId,
        reportCategoryId: reportCategoryId,
        description: description,
        street: street,
        number: number,
        complement: complement,
        neighborhood: neighborhood,
        city: city,
        state: state,
        postalCode: postalCode,
        coordinates: coordinates,
      );

      final response = Response(
        200,
        body: SuccessResponseModel.Response(
          message: "Report created successfully",
          data: createReportResponse.ReportResponse(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "Failed to create report",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _GetReports(Request request) async {
    try {
      final getReportsResponse = await this._m_reportRepository.GetReports();

      final response = Response(
        200,
        body: SuccessResponseModel.Response(
          message: "Reports found successfully",
          data: getReportsResponse.map((aux) => aux.ReportResponse()).toList(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "Failed to get reports",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _GetReportById(Request request) async {
    try {
      final id = request.params['id']!;
      final getReportByIdResponse = await this._m_reportRepository
          .GetReportById(id: id);

      final response = Response(
        200,
        body: SuccessResponseModel.Response(
          message: "Report found successfully",
          data: getReportByIdResponse.ReportResponse(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "Failed to find report",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _GetReportsByUserId(Request request) async {
    try {
      final userId = request.params['user_id']!;
      final getReportsResponse = await this._m_reportRepository
          .GetReportsByUserId(userId: userId);

      final response = Response(
        200,
        body: SuccessResponseModel.Response(
          message: "Reports found successfully",
          data: getReportsResponse.map((aux) => aux.ReportResponse()).toList(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "Failed to get reports",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _GetReportsByReportCategoryId(Request request) async {
    try {
      final reportCategoryId = request.params['report_category_id']!;
      final getReportsResponse = await this._m_reportRepository
          .GetReportsByReportCategoryId(reportCategoryId: reportCategoryId);

      final response = Response(
        200,
        body: SuccessResponseModel.Response(
          message: "Reports found successfully",
          data: getReportsResponse.map((aux) => aux.ReportResponse()).toList(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "Failed to get reports",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _UpdateReport(Request request) async {
    try {
      final data =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final id = request.params['id']!;
      final userId = request.context['userId'] as String;
      final description = data['description'] as String?;

      final updateReportResponse = await this._m_reportRepository.UpdateReport(
        id: id,
        userId: userId,
        description: description,
      );
      final response = Response(
        200,
        body: SuccessResponseModel.Response(
          message: "Report updated successfully",
          data: updateReportResponse.ReportResponse(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "Failed to update report",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _DeleteReport(Request request) async {
    try {
      final id = request.params['id']!;
      final userId = request.context['userId'] as String;

      final updateReportResponse = await this._m_reportRepository.DeleteReport(
        id: id,
        userId: userId,
      );
      final response = Response(
        200,
        body: SuccessResponseModel.Response(
          message: "Report deleted successfully",
          data: updateReportResponse.ReportResponse(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "Failed to delete report",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }
}

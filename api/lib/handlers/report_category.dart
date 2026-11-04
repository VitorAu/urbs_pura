import 'dart:convert';

import 'package:api/handlers/responses/error.dart';
import 'package:api/handlers/responses/success.dart';
import 'package:api/repositories/report_category.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ReportCategoryHandler {
  final ReportCategoryRepository _m_reportCategoryRepository;

  ReportCategoryHandler(ReportCategoryRepository reportCategoryRepository)
    : _m_reportCategoryRepository = reportCategoryRepository;

  Router get router {
    final router = Router();

    router.post('/', this._CreateReportCategory);
    router.get('/', this._GetReportCategories);
    router.get('/<id>', this._GetReportCategoryById);
    router.get('/title/<title>', this._GetReportCategoryByTitle);
    // router.patch('/', this._UpdateReportCategory);
    // router.delete('/', this._DeleteReportCategory);

    return router;
  }

  Future<Response> _CreateReportCategory(Request request) async {
    try {
      final data =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final title = data['title'] as String;
      final description = data['description'] as String?;
      final createReportCategoryResponse = await this
          ._m_reportCategoryRepository
          .CreateReportCategory(title: title, description: description);

      final response = Response(
        200,
        body: SuccessResponse.Response(
          message: "Report category created successfully",
          data: createReportCategoryResponse.ReportCategoryResponse(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponse.Response(
          message: "Failed to create report category",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _GetReportCategories(Request request) async {
    try {
      final getReportCategoryResponse = await this
          ._m_reportCategoryRepository
          .GetReportCategories();

      final response = Response(
        200,
        body: SuccessResponse.Response(
          message: "Report categories found successfully",
          data: getReportCategoryResponse
              .map((aux) => aux.ReportCategoryResponse())
              .toList(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponse.Response(
          message: "Failed to find report categories",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _GetReportCategoryById(Request request) async {
    try {
      final id = request.params['id']!;
      final getReportCategoryByIdResponse = await this
          ._m_reportCategoryRepository
          .GetReportCategoryById(id: id);

      final response = Response(
        200,
        body: SuccessResponse.Response(
          message: "Report category found successfully",
          data: getReportCategoryByIdResponse.ReportCategoryResponse(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponse.Response(
          message: "Failed to find report category",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _GetReportCategoryByTitle(Request request) async {
    try {
      final title = request.params['title']!;
      final getReportCategoryByTitleResponse = await this
          ._m_reportCategoryRepository
          .GetReportCategoryByTitle(title: title);

      final response = Response(
        200,
        body: SuccessResponse.Response(
          message: "Report category found successfully",
          data: getReportCategoryByTitleResponse.ReportCategoryResponse(),
        ),
        headers: {'content-type': 'application/json'},
      );

      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponse.Response(
          message: "Failed to find report category",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }
}

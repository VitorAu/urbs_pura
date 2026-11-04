import 'package:api/models/report.dart';

abstract class ReportInterface {
  Future<ReportModel> CreateReport({
    required String userId,
    required String reportCategoryId,
    String? description,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
    String? postalCode,
    required CoordinatesType coordinates,
  });
  Future<List<ReportModel>> GetReports();
  Future<ReportModel> GetReportById({required String id});
  Future<List<ReportModel>> GetReportsByUserId({required String userId});
  Future<List<ReportModel>> GetReportsByReportCategoryId({required String reportCategoryId});
  Future<ReportModel> UpdateReport({required String id, required String userId, String? description});
  Future<ReportModel> DeleteReport({required String id, required String userId});
}

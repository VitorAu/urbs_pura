import 'package:api/models/report.dart';

abstract class ReportInterface {
  Future<ReportModel> CreateReport({
    required String userId,
    required String reportCategoryId,
    String? description,
    required String street,
    required String number,
    String? complement,
    required String neighborhood,
    required String city,
    required String state,
    required String postalCode,
    required CoordinatesType coordinates,
  });
  Future<List<ReportModel>> GetReports();
  Future<ReportModel> GetReportById({required String id});
  Future<List<ReportModel>> GetReportsByUserId({required String userId});
  Future<List<ReportModel>> GetReportsByReportCategoryId({required String reportCategoryId});
  Future<ReportModel> UpdateReport({required String id, required String userId});
  Future<void> DeleteReport({required String id, required String userId});
}

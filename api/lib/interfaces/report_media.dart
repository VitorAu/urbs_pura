import 'package:api/models/report_media.dart';

abstract class ReportMediaInterface {
  Future<({ReportMediaModel model, Uri uploadUrl})> CreateReportMedia({
    required String reportId,
    required int sortOrder,
  });
  Future<({ReportMediaModel model, Uri downloadUrl})> GetReportMediaById({
    required String id,
  });
  Future<List<({ReportMediaModel model, Uri downloadUrl})>>
  GetReportMediasByReportId({required String reportId});
  Future<ReportMediaModel> UpdateReportMedia({
    required String id,
    required int sortOrder,
  });
  Future<ReportMediaModel> DeleteReportMedia({required String id});
}

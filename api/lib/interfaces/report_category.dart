import 'package:api/models/report_category.dart';

abstract class ReportCategoryInterface {
  Future<ReportCategoryModel> CreateReportCategory({
    required String title,
    String? description,
  });
  Future<List<ReportCategoryModel>> GetReportCategories();
  Future<ReportCategoryModel> GetReportCategoryById({required String id});
  Future<ReportCategoryModel> GetReportCategoryByTitle({required String title});
  Future<ReportCategoryModel> UpdateReportCategory({
    required String id,
    String? title,
    String? description,
  });
  Future<void> DeleteReportCategory({required String id});
}

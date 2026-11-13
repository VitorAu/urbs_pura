import 'package:api/interfaces/report_category.dart';
import 'package:api/models/report_category.dart';
import 'package:postgres/postgres.dart';

class ReportCategoryRepository extends ReportCategoryInterface {
  final Future<Connection> _m_connection;

  ReportCategoryRepository(Future<Connection> connection)
    : _m_connection = connection;

  @override
  Future<ReportCategoryModel> CreateReportCategory({
    required String title,
    String? description,
  }) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        INSERT INTO report_categories (
          title,
          description
        )
        VALUES (
          @title,
          @description
        )
        RETURNING *
      '''),
      parameters: {'title': title, 'description': description},
    );

    if (data.isEmpty) throw new Exception("Failed to create report category");
    final response = ReportCategoryModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<List<ReportCategoryModel>> GetReportCategories() async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM report_categories
        WHERE deleted_at IS NULL
      '''),
    );

    final response = data
        .map((aux) => ReportCategoryModel.FromDatabase(aux.toColumnMap()))
        .toList();
    return response;
  }

  @override
  Future<ReportCategoryModel> GetReportCategoryById({
    required String id,
  }) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM report_categories
        WHERE id = @id
        AND deleted_at IS NULL
        LIMIT 1
      '''),
      parameters: {'id': id},
    );

    if (data.isEmpty) throw new Exception("Failed to find report category");
    final response = ReportCategoryModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<ReportCategoryModel> GetReportCategoryByTitle({
    required String title,
  }) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM report_categories
        WHERE title = @title
        AND deleted_at IS NULL
        LIMIT 1
      '''),
      parameters: {'title': title},
    );

    if (data.isEmpty) throw new Exception("Failed to find report category");
    final response = ReportCategoryModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<ReportCategoryModel> UpdateReportCategory({
    required String id,
    String? title,
    String? description,
  }) {
    // TODO: implement UpdateReportCategory
    throw UnimplementedError();
  }

  @override
  Future<void> DeleteReportCategory({required String id}) {
    // TODO: implement DeleteReportCategory
    throw UnimplementedError();
  }
}

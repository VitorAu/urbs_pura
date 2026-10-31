import 'package:api/interfaces/report.dart';
import 'package:api/models/report.dart';
import 'package:postgres/postgres.dart';

class ReportRepository extends ReportInterface {
  final Future<Connection> _m_connection;

  ReportRepository(Future<Connection> connection) : _m_connection = connection;

  @override
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
  }) async {
    final connection = await this._m_connection;

    final data = await connection.execute(
      Sql.named('''
      INSERT INTO reports (
        user_id,
        report_category_id,
        description,
        street,
        number,
        complement,
        neighborhood,
        city,
        state,
        postal_code,
        coordinates
      )
      VALUES (
        @userId,
        @reportCategoryId,
        @description,
        @street,
        @number,
        @complement,
        @neighborhood,
        @city,
        @state,
        @postalCode,
        ST_SetSRID(
          ST_MakePoint(@longitude, @latitude),
          4326
        )::geography
      )
      RETURNING *
    '''),
      parameters: {
        'userId': userId,
        'reportCategoryId': reportCategoryId,
        'description': description,
        'street': street,
        'number': number,
        'complement': complement,
        'neighborhood': neighborhood,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'longitude': coordinates.longitude,
        'latitude': coordinates.latitude,
      },
    );

    if (data.isEmpty) throw new Exception('Failed to create report');
    final response = ReportModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<List<ReportModel>> GetReports() async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM reports
        WHERE deleted_at IS NULL
      '''),
    );

    final response = data
        .map((aux) => ReportModel.FromDatabase(aux.toColumnMap()))
        .toList();
    return response;
  }

  @override
  Future<ReportModel> GetReportById({required String id}) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM reports
        WHERE id = @id
        AND deleted_at IS NULL
        LIMIT 1
      '''),
      parameters: {'id': id},
    );

    if (data.isEmpty) throw new Exception("Failed to find report");
    final response = ReportModel.FromDatabase(data.first.toColumnMap());
    return response;
  }

  @override
  Future<List<ReportModel>> GetReportsByUserId({required String userId}) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM reports
        WHERE user_id = @user_id
        AND deleted_at IS NULL
        LIMIT 1
      '''),
      parameters: {'user_id': userId},
    );

    if (data.isEmpty) throw new Exception("Failed to find report");
    final response = data
        .map((aux) => ReportModel.FromDatabase(aux.toColumnMap()))
        .toList();
    return response;
  }

  @override
  Future<List<ReportModel>> GetReportsByReportCategoryId({
    required String reportCategoryId,
  }) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM reports
        WHERE report_category_id = @report_category_id
        AND deleted_at IS NULL
        LIMIT 1
      '''),
      parameters: {'report_category_id': reportCategoryId},
    );

    if (data.isEmpty) throw new Exception("Failed to find report");
    final response = data
        .map((aux) => ReportModel.FromDatabase(aux.toColumnMap()))
        .toList();
    return response;
  }

  @override
  Future<ReportModel> UpdateReport({
    required String id,
    required String userId,
    String? description,
  }) async {
    // TODO: implement DeleteReport
    throw UnimplementedError();
  }

  @override
  Future<void> DeleteReport({required String id, required String userId}) {
    // TODO: implement DeleteReport
    throw UnimplementedError();
  }
}

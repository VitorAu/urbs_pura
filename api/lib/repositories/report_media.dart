import 'dart:math';

import 'package:api/interfaces/report_media.dart';
import 'package:api/models/report_media.dart';
import 'package:api/services/s3.dart';
import 'package:postgres/postgres.dart';

class ReportMediaRepository extends ReportMediaInterface {
  final Future<Connection> _m_connection;
  final S3Service _m_s3Service;

  ReportMediaRepository(Future<Connection> connection, S3Service s3Service)
    : _m_connection = connection,
      _m_s3Service = s3Service;

  String _GenRandomKey(String reportId) {
    final random = Random.secure();
    final randomList = List.generate(25, (_) => random.nextInt(256));
    final randomBytes = randomList
        .map((byte) => byte.toRadixString(16).toUpperCase().padLeft(2, '0'))
        .join();

    final aux = '$reportId/$randomBytes';
    return aux;
  }

  @override
  Future<({ReportMediaModel model, Uri uploadUrl})> CreateReportMedia({
    required String reportId,
    required int sortOrder,
  }) async {
    final connection = await this._m_connection;
    String key = this._GenRandomKey(reportId);
    final uploadUrl = await this._m_s3Service.GenerateUploadUrl(key: key);

    final data = await connection.execute(
      Sql.named('''
        INSERT INTO report_medias (
          report_id,
          key,
          sort_order
        )
        VALUES (
          @report_id,
          @key,
          @sort_order
        )
        RETURNING *
      '''),
      parameters: {'report_id': reportId, 'key': key, 'sort_order': sortOrder},
    );

    if (data.isEmpty) throw new Exception("Failed to create report media");
    final response = ReportMediaModel.FromDatabase(data.first.toColumnMap());
    return (model: response, uploadUrl: uploadUrl);
  }

  @override
  Future<({ReportMediaModel model, Uri downloadUrl})> GetReportMediaById({required String id}) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM report_medias
        WHERE id = @id
        AND deleted_at IS NULL
        LIMIT 1
      '''),
      parameters: {'id': id},
    );

    if (data.isEmpty) throw new Exception("Failed to get report media");

    final response = ReportMediaModel.FromDatabase(data.first.toColumnMap());
    final downloadUrl = await this._m_s3Service.GenerateDownloadUrl(key: response.m_key);

    return (model: response, downloadUrl: downloadUrl);
  }

  @override
  Future<List<({ReportMediaModel model, Uri downloadUrl})>> GetReportMediasByReportId({
    required String reportId,
  }) async {
    final connection = await this._m_connection;
    final data = await connection.execute(
      Sql.named('''
        SELECT * FROM report_medias
        WHERE report_id = @report_id
        AND deleted_at IS NULL
        ORDER BY sort_order ASC
      '''),
      parameters: {'report_id': reportId},
    );

    final result = data
        .map((aux) => ReportMediaModel.FromDatabase(aux.toColumnMap()))
        .toList();
    final downloadUrl = await Future.wait(List.generate(result.length,  (aux) async => await this._m_s3Service.GenerateDownloadUrl(key: result[aux].m_key)));
    final response = List.generate(result.length, (aux) => (
      model: result[aux],
      downloadUrl: downloadUrl[aux]
    ));
    
    return response;
  }

  @override
  Future<ReportMediaModel> UpdateReportMedia({
    required String id,
    required int sortOrder,
  }) {
    // TODO: implement UpdateReportMedia
    throw UnimplementedError();
  }

  @override
  Future<ReportMediaModel> DeleteReportMedia({required String id}) {
    // TODO: implement DeleteReportMedia
    throw UnimplementedError();
  }
}

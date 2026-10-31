import 'package:api/interfaces/report.dart';
import 'package:api/models/report.dart';
import 'package:postgres/postgres.dart';

class ReportRepository extends ReportInterface {
   final Future<Connection> _m_connection;

  ReportRepository(Future<Connection> connection)
    : _m_connection = connection;

  @override
  Future<ReportModel> CreateReport({required String userId, required String reportCategoryId, String? description, required String street, required String number, String? complement, required String neighborhood, required String city, required String state, required String postalCode, required CoordinatesType coordinates}) {
    // TODO: implement CreateReport
    throw UnimplementedError();
  }

  @override
  Future<List<ReportModel>> GetReports() {
    // TODO: implement GetReports
    throw UnimplementedError();
  }

  @override
  Future<ReportModel> GetReportById({required String id}) {
    // TODO: implement GetReportById
    throw UnimplementedError();
  }

  @override
  Future<List<ReportModel>> GetReportsByUserId({required String userId}) {
    // TODO: implement GetReportsByUserId
    throw UnimplementedError();
  }

  @override
  Future<List<ReportModel>> GetReportsByReportCategoryId({required String reportCategoryId}) {
    // TODO: implement GetReportsByReportCategoryId
    throw UnimplementedError();
  }

  @override
  Future<ReportModel> UpdateReport({required String id, required String userId}) {
    // TODO: implement UpdateReport
    throw UnimplementedError();
  }

  @override
  Future<void> DeleteReport({required String id, required String userId}) {
    // TODO: implement DeleteReport
    throw UnimplementedError();
  }
}

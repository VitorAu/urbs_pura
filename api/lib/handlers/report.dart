import 'package:api/repositories/report.dart';
import 'package:shelf_router/shelf_router.dart';

class ReportHandler {
  final ReportRepository _m_reportRepository;

  ReportHandler(ReportRepository reportRepository)
    : _m_reportRepository = reportRepository;

  Router get router {
    final router = Router();

    router.post('/', this._CreateReport);
    router.get('/', this._GetReports);
    router.get('/', this._GetReports);
    router.get('/<id>', this._GetReportById);
    router.get('/user/<userId>', this._GetReportsByUserId);
    router.get('/report_category/<reportCategoryId>', this._GetReportsByReportCategoryId);

    return router;
  }
}

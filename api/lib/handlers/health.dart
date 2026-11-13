import 'package:api/repositories/health.dart';
import 'package:api/models/responses/error.dart';
import 'package:api/models/responses/success.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class HealthHandler {
  final HealthRepository _m_healthRepository;

  HealthHandler(HealthRepository healthRepository)
    : _m_healthRepository = healthRepository;

  Router get router {
    final router = Router();

    router.get('/api', this._GetApiHealth);
    router.get('/db', this._GetDatabaseHealth);

    return router;
  }

  Future<Response> _GetApiHealth(Request request) async {
    try {
      final response = Response(
        200,
        body: SuccessResponseModel.ResponseNoData(message: "API is healthy"),
        headers: {'content-type': 'application/json'},
      );
      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "API is not healthy",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }

  Future<Response> _GetDatabaseHealth(Request request) async {
    try {
      final data = await this._m_healthRepository.GetDatabaseHealth();

      if (!data) {
        final response = Response.internalServerError(
          body: ErrorResponseModel.Response(
            message: "DB is not healthy",
            error: "Database health check failed",
          ),
          headers: {'content-type': 'application/json'},
        );
        return response;
      }

      final response = Response.ok(
        SuccessResponseModel.ResponseNoData(message: "DB is healthy"),
        headers: {'content-type': 'application/json'},
      );
      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ErrorResponseModel.Response(
          message: "DB is not healthy",
          error: err.toString(),
        ),
        headers: {'content-type': 'application/json'},
      );
      return response;
    }
  }
}

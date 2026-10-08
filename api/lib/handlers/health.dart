import 'package:api/models/response.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class HealthHandler {
  Connection _m_connection;

  HealthHandler(Connection connection): _m_connection = connection;

  Router get router {
    final router = Router();
    router.get('/api', _GetApiHealth);
    router.get('/db', _GetDatabaseHealth);
    return router;
  }

  Future<Response> _GetApiHealth(Request request) async {
    try {
      final response = Response.ok(
        ResponseModel.SuccessNoDataResponse(message: "API is healthy"),
        headers: {'content-type': 'application/json'},
      );
      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ResponseModel.ErrorResponse(
          message: "API is not healthy",
          error: err.toString(),
        ),
      );
      return response;
    }
  }

  Future<Response> _GetDatabaseHealth(Request request) async {
    try {
      await this._m_connection.execute('SELECT 1');

      final response = Response.ok(
        ResponseModel.SuccessNoDataResponse(message: "DB is healthy"),
        headers: {'content-type': 'application/json'},
      );
      return response;
    } catch (err) {
      final response = Response.internalServerError(
        body: ResponseModel.ErrorResponse(
          message: "DB is not healthy",
          error: err.toString(),
        ),
      );
      return response;
    }
  }
}


import 'package:app/config/environment.dart';
import 'package:app/config/token.dart';
import 'package:app/models/response/error.dart';
import 'package:app/models/response/success.dart';
import 'package:dio/dio.dart';

class Api {
  late final Dio m_dio;

  Api() {
    m_dio = Dio(
      BaseOptions(
        baseUrl: Environment.ApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    m_dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path.endsWith('/auth/refresh')) {
            return handler.next(options);
          }

          final accessToken = await Token.GetAccessToken();

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          handler.next(options);
        },

        onError: (error, handler) async {
          final request = error.requestOptions;

          final isUnauthorized = error.response?.statusCode == 401;
          final isRefreshRequest =
              request.path.endsWith('/auth/refresh');
          final alreadyRetried = request.extra['retried'] == true;

          if (!isUnauthorized || isRefreshRequest || alreadyRetried) {
            return handler.next(error);
          }

          try {
            final refreshToken = await Token.GetRefreshToken();

            if (refreshToken == null) {
              await Token.Delete();
              return handler.next(error);
            }

            final refreshResponse = await m_dio.post(
              '/auth/refresh',
              data: {'refreshToken': refreshToken},
            );

            final responseData =
                refreshResponse.data as Map<String, dynamic>;

            final data = responseData['data'] as Map<String, dynamic>;

            final newAccessToken = data['accessToken'] as String;

            await Token.Save(
              accessToken: newAccessToken,
              refreshToken: refreshToken,
            );

            request.headers['Authorization'] =
                'Bearer $newAccessToken';

            request.extra['retried'] = true;

            final retryResponse = await m_dio.fetch(request);

            return handler.resolve(retryResponse);
          } catch (_) {
            await Token.Delete();
            return handler.next(error);
          }
        },
      ),
    );
  }

  Future<dynamic> Request<T>({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await m_dio.request(
        endpoint,
        data: body,
        options: Options(method: method),
      );

      print('API RESPONSE: ${response.data}');

      return SuccessResponseModel<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJson: fromJson,
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        return ErrorResponseModel.fromJson(data);
      }

      rethrow;
    }
  }
}

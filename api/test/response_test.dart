import 'dart:convert';

import 'package:api/handlers/responses/error.dart';
import 'package:api/handlers/responses/success.dart';
import 'package:test/test.dart';

void main() {
  group('SuccessResponse', () {
    test('returns success response with data', () {
      final response = SuccessResponse.Response(
        message: 'Operation completed',
        data: {'id': 1},
      );

      final decoded = jsonDecode(response) as Map<String, dynamic>;

      expect(decoded['status'], 'SUCCESS');
      expect(decoded['message'], 'Operation completed');
      expect(decoded['data'], {'id': 1});
    });

    test('returns success response without data', () {
      final response = SuccessResponse.ResponseNoData(
        message: 'API is healthy',
      );

      final decoded = jsonDecode(response) as Map<String, dynamic>;

      expect(decoded['status'], 'SUCCESS');
      expect(decoded['message'], 'API is healthy');
      expect(decoded.containsKey('data'), isFalse);
    });
  });

  group('ErrorResponse', () {
    test('returns error response', () {
      final response = ErrorResponse.Response(
        message: 'Request failed',
        error: 'Invalid request',
      );

      final decoded = jsonDecode(response) as Map<String, dynamic>;

      expect(decoded['status'], 'ERROR');
      expect(decoded['message'], 'Request failed');
      expect(decoded['error'], 'Invalid request');
    });
  });
}

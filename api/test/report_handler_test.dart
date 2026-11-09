import 'dart:convert';

import 'package:api/handlers/report.dart';
import 'package:api/interfaces/report.dart';
import 'package:api/models/report.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class FakeReportRepository implements ReportInterface {
  int? lastPage;
  int? lastLimit;

  @override
  Future<int> GetReportsCount() async {
    return 45;
  }

  @override
  Future<List<ReportModel>> GetReports({
    required int page,
    required int limit,
  }) async {
    lastPage = page;
    lastLimit = limit;

    return [];
  }

  @override
  Future<ReportModel> CreateReport({
    required String userId,
    required String reportCategoryId,
    String? description,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
    String? postalCode,
    required CoordinatesType coordinates,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ReportModel> GetReportById({required String id}) async {
    throw UnimplementedError();
  }

  @override
  Future<List<ReportModel>> GetReportsByUserId({required String userId}) async {
    throw UnimplementedError();
  }

  @override
  Future<List<ReportModel>> GetReportsByReportCategoryId({
    required String reportCategoryId,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ReportModel> UpdateReport({
    required String id,
    required String userId,
    String? description,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ReportModel> DeleteReport({
    required String id,
    required String userId,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  group('ReportHandler pagination', () {
    test('uses default pagination values', () async {
      final repository = FakeReportRepository();
      final handler = ReportHandler(repository).router;

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/')),
      );

      final body = jsonDecode(await response.readAsString());

      expect(response.statusCode, 200);
      expect(repository.lastPage, 1);
      expect(repository.lastLimit, 20);
      expect(body['pagination']['currentPage'], 1);
      expect(body['pagination']['perPage'], 20);
      expect(body['pagination']['totalItems'], 45);
      expect(body['pagination']['totalPages'], 3);
    });

    test('accepts custom pagination values', () async {
      final repository = FakeReportRepository();
      final handler = ReportHandler(repository).router;

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/?page=2&limit=10')),
      );

      final body = jsonDecode(await response.readAsString());

      expect(response.statusCode, 200);
      expect(repository.lastPage, 2);
      expect(repository.lastLimit, 10);
      expect(body['pagination']['currentPage'], 2);
      expect(body['pagination']['perPage'], 10);
      expect(body['pagination']['totalPages'], 5);
    });

    test('rejects page smaller than 1', () async {
      final repository = FakeReportRepository();
      final handler = ReportHandler(repository).router;

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/?page=0')),
      );

      expect(response.statusCode, 400);
    });

    test('rejects limit greater than 100', () async {
      final repository = FakeReportRepository();
      final handler = ReportHandler(repository).router;

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/?limit=101')),
      );

      expect(response.statusCode, 400);
    });

    test('rejects limit smaller than 1', () async {
      final repository = FakeReportRepository();
      final handler = ReportHandler(repository).router;

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/?limit=0')),
      );

      expect(response.statusCode, 400);
    });

    test('rejects non-numeric page', () async {
      final repository = FakeReportRepository();
      final handler = ReportHandler(repository).router;

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/?page=abc')),
      );

      expect(response.statusCode, 400);
    });
  });
}

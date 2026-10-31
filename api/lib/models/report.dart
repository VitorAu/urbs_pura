import 'dart:convert';

import 'package:postgres/postgres.dart';

enum ReportEnum { PENDING, IN_PROGRESS, RESOLVED }

typedef CoordinatesType = ({double longitude, double latitude});

class ReportModel {
  final String m_id;
  final String m_userId;
  final String m_reportCategoryId;
  final String? m_description;
  final ReportEnum m_status;
  final String m_street;
  final String m_number;
  final String? m_complement;
  final String m_neighborhood;
  final String m_city;
  final String m_state;
  final String m_postalCode;
  final CoordinatesType m_coordinates;
  final DateTime m_createdAt;
  final DateTime m_updatedAt;
  final DateTime? m_deletedAt;

  ReportModel({
    required String id,
    required String userId,
    required String reportCategoryId,
    String? description,
    required ReportEnum status,
    required String street,
    required String number,
    String? complement,
    required String neighborhood,
    required String city,
    required String state,
    required String postalCode,
    required CoordinatesType coordinates,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : this.m_id = id,
       this.m_userId = userId,
       this.m_reportCategoryId = reportCategoryId,
       this.m_description = description,
       this.m_status = status,
       this.m_street = street,
       this.m_number = number,
       this.m_complement = complement,
       this.m_neighborhood = neighborhood,
       this.m_city = city,
       this.m_state = state,
       this.m_postalCode = postalCode,
       this.m_coordinates = coordinates,
       this.m_createdAt = createdAt,
       this.m_updatedAt = updatedAt,
       this.m_deletedAt = deletedAt;

  ReportModel.FromDatabase(Map<String, dynamic> row)
    : this.m_id = row['id'] as String,
      this.m_userId = row['user_id'] as String,
      this.m_reportCategoryId = row['report_category_id'] as String,
      this.m_description = row['description'] as String?,
      this.m_status = ReportEnum.values.byName(
        utf8.decode((row['status'] as UndecodedBytes).bytes),
      ),
      this.m_street = row['street'] as String,
      this.m_number = row['number'] as String,
      this.m_complement = row['complement'] as String?,
      this.m_neighborhood = row['neighborhood'] as String,
      this.m_city = row['city'] as String,
      this.m_state = row['state'] as String,
      this.m_postalCode = row['postal_code'] as String,
      this.m_coordinates = (
        longitude: row['longitude'] as double,
        latitude: row['latitude'] as double,
      ),
      this.m_createdAt = row['created_at'] as DateTime,
      this.m_updatedAt = row['updated_at'] as DateTime,
      this.m_deletedAt = row['deleted_at'] as DateTime?;

  Map<String, dynamic> ReportResponse() {
    final response = {
      'id': this.m_id,
      'userId': this.m_userId,
      'reportCategoryId': this.m_reportCategoryId,
      'description': this.m_description,
      'status': this.m_status.name,
      'street': this.m_street,
      'number': this.m_number,
      'complement': this.m_complement,
      'neighborhood': this.m_neighborhood,
      'city': this.m_city,
      'state': this.m_state,
      'postalCode': this.m_postalCode,
      'coordinates': {
        'longitude': this.m_coordinates.longitude,
        'latitude': this.m_coordinates.latitude,
      },
      'createdAt': this.m_createdAt.toIso8601String(),
      'updatedAt': this.m_updatedAt.toIso8601String(),
      'deletedAt': this.m_deletedAt?.toIso8601String(),
    };

    return response;
  }
}

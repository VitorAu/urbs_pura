import 'dart:convert';

import 'package:postgres/postgres.dart';

class ReportCategoryModel {
  final String m_id;
  final String m_title;
  final String m_description;
  final DateTime m_createdAt;
  final DateTime m_updatedAt;
  final DateTime? m_deletedAt;

  ReportCategoryModel({
    required String id,
    required String title,
    required String description,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : m_id = id,
       m_title = title,
       m_description = description,
       m_createdAt = createdAt,
       m_updatedAt = updatedAt,
       m_deletedAt = deletedAt;
  
  ReportCategoryModel.FromDatabase(Map<String, dynamic> row)
    : m_id = row["id"] as String,
      m_title = row["title"] as String,
      m_description = row["description"] as String,
      m_createdAt = row["created_at"] as DateTime,
      m_updatedAt = row["updated_at"] as DateTime,
      m_deletedAt = row["deleted_at"] as DateTime?;

  Map<String, dynamic> ReportCategoryResponse() {
    final response = {
      "id": this.m_id,
      "title": this.m_title,
      "description": this.m_description,
      "createdAt": this.m_createdAt.toIso8601String(),
      "updatedAt": this.m_updatedAt.toIso8601String(),
      "deletedAt": this.m_deletedAt?.toIso8601String(),
    };

    return response;
  }
}

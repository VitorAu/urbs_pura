import 'dart:convert';

import 'package:postgres/postgres.dart';

enum MediaEnum { IMAGE, VIDEO }

class ReportMediaModel {
  final String m_id;
  final String m_reportId;
  final String m_key;
  final int m_sortOrder;
  final MediaEnum m_mediaEnum;
  final DateTime m_createdAt;
  final DateTime m_updatedAt;
  final DateTime? m_deletedAt;

  ReportMediaModel({
    required String id,
    required String reportId,
    required String key,
    required int sortOrder,
    required MediaEnum mediaEnum,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : m_id = id,
       m_reportId = reportId,
       m_key = key,
       m_sortOrder = sortOrder,
       m_mediaEnum = mediaEnum,
       m_createdAt = createdAt,
       m_updatedAt = updatedAt,
       m_deletedAt = deletedAt;

  factory ReportMediaModel.FromDatabase(Map<String, dynamic> row) {
    return ReportMediaModel(
      id: row["id"] as String,
      reportId: row["report_id"] as String,
      key: row["key"] as String,
      sortOrder: row["sort_order"] as int,
      mediaEnum: MediaEnum.values.byName(
        utf8.decode((row["media"] as UndecodedBytes).bytes),
      ),
      createdAt: row["created_at"] as DateTime,
      updatedAt: row["updated_at"] as DateTime,
      deletedAt: row["deleted_at"] as DateTime?,
    );
  }

  Map<String, dynamic> ReportMediaResponse() {
    final response = {
      "id": this.m_id,
      "report_id": this.m_reportId,
      "key": this.m_key,
      "sort_order": this.m_sortOrder,
      "media": this.m_mediaEnum.name,
      "createdAt": this.m_createdAt.toIso8601String(),
      "updatedAt": this.m_updatedAt.toIso8601String(),
      "deletedAt": this.m_deletedAt?.toIso8601String(),
    };

    return response;
  }
}

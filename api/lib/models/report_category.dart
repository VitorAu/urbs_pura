class ReportCategoryModel {
  final String m_id;
  final String m_title;
  final String? m_description;
  final DateTime m_createdAt;
  final DateTime m_updatedAt;
  final DateTime? m_deletedAt;

  ReportCategoryModel({
    required String id,
    required String title,
    String? description,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : this.m_id = id,
       this.m_title = title,
       this.m_description = description,
       this.m_createdAt = createdAt,
       this.m_updatedAt = updatedAt,
       this.m_deletedAt = deletedAt;

  ReportCategoryModel.FromDatabase(Map<String, dynamic> row)
    : this.m_id = row["id"] as String,
      this.m_title = row["title"] as String,
      this.m_description = row["description"] as String?,
      this.m_createdAt = row["created_at"] as DateTime,
      this.m_updatedAt = row["updated_at"] as DateTime,
      this.m_deletedAt = row["deleted_at"] as DateTime?;

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


class Report {
  final String id;
  final String userId;
  final String reportCategoryId;
  final String description;
  final String status;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.reportCategoryId,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    final coordinates =
        Map<String, dynamic>.from(json['coordinates'] as Map);

    return Report(
      id: json['id'] as String,
      userId: json['userId'] as String,
      reportCategoryId: json['reportCategoryId'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      latitude: (coordinates['latitude'] as num).toDouble(),
      longitude: (coordinates['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class ReportCategoryModel {
  final String id;
  final String title;
  final String? description;

  ReportCategoryModel({
    required this.id,
    required this.title,
    this.description,
  });

  factory ReportCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReportCategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
    );
  }
}

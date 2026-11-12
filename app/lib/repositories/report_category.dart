import 'package:app/config/api.dart';
import 'package:app/models/report_category.dart';
import 'package:app/models/response/success.dart';

class ReportCategoryRepository {
  final Api _api = Api();

  Future<SuccessResponseModel<ReportCategoryModel>> createCategory({
    required String title,
    String? description,
  }) async {
    final response = await _api.Request<ReportCategoryModel>(
      method: 'POST',
      endpoint: '/report_category/',
      body: {'title': title, 'description': description},
      fromJson: (data) {
        return ReportCategoryModel.fromJson(data as Map<String, dynamic>);
      },
    );

    if (response is SuccessResponseModel<ReportCategoryModel>) {
      return response;
    }

    throw Exception('Não foi possível criar a categoria.');
  }

  Future<SuccessResponseModel<List<ReportCategoryModel>>>
  getCategories() async {
    final response = await _api.Request<List<ReportCategoryModel>>(
      method: 'GET',
      endpoint: '/report_category/',
      fromJson: (data) {
        return (data as List)
            .map(
              (item) =>
                  ReportCategoryModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      },
    );

    if (response is SuccessResponseModel<List<ReportCategoryModel>>) {
      return response;
    }

    throw Exception('Não foi possível carregar as categorias.');
  }
}


import 'package:app/models/response/error.dart';
import 'package:flutter/material.dart';
import 'package:app/models/report.dart';
import 'package:app/models/response/success.dart';
import 'package:app/repositories/report_media.dart';

class ReportDetails extends StatefulWidget {
  final Report report;
  final String categoryTitle;

  const ReportDetails({
    super.key,
    required this.report,
    required this.categoryTitle,
  });

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  final ReportMediaRepository _mediaRepository = ReportMediaRepository();

  late Future<List<Map<String, dynamic>>> _mediaFuture;

  @override
  void initState() {
    super.initState();
    _mediaFuture = _LoadMedia();
  }

  Future<List<Map<String, dynamic>>> _LoadMedia() async {
    final response = await _mediaRepository.getReportMediasByReportId(
      reportId: widget.report.id,
    );

    if (response is ErrorResponseModel) {
      throw Exception(response.m_message);
    }

    if (response is! SuccessResponseModel<List<Map<String, dynamic>>>) {
      throw Exception('Resposta inesperada ao buscar fotografias.');
    }

    return response.m_data ?? [];
  }

  Widget _ReadOnlyField({
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da denúncia'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Denúncia registrada',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _ReadOnlyField(
              label: 'Categoria',
              value: widget.categoryTitle,
            ),

            const SizedBox(height: 20),

            _ReadOnlyField(
              label: 'Descrição',
              value: report.description,
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            _ReadOnlyField(
              label: 'Status',
              value: report.status,
            ),

            const SizedBox(height: 20),

            const Text(
              'Localização da ocorrência',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Latitude: ${report.latitude.toStringAsFixed(6)}',
            ),
            Text(
              'Longitude: ${report.longitude.toStringAsFixed(6)}',
            ),

            const SizedBox(height: 20),

            _ReadOnlyField(
              label: 'Data de registro',
              value: report.createdAt.toLocal().toString(),
            ),

            const SizedBox(height: 20),

            const Text(
              'Fotografias',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: _mediaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Text(
                    'Não foi possível carregar as fotografias.',
                  );
                }

                final medias = snapshot.data ?? [];

                if (medias.isEmpty) {
                  return const Text(
                    'Nenhuma fotografia disponível.',
                  );
                }

                return Column(
                  children: medias.map((media) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          media['download_url'] as String,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              'Não foi possível carregar esta fotografia.',
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

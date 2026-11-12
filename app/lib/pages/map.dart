import 'package:app/models/report.dart';
import 'package:app/models/response/success.dart';
import 'package:app/repositories/report.dart';
import 'package:app/repositories/report_category.dart';
import 'package:app/widgets/report_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/widgets/report_form.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final ReportRepository _reportRepository = ReportRepository();
  final ReportCategoryRepository _categoryRepository =
      ReportCategoryRepository();

  bool selecionandoLocal = false;
  bool _loading = true;
  LatLng? localSelecionado;

  List<Report> _reports = [];
  Map<String, String> _categories = {};

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    if (!mounted) return;
    setState(() => _loading = true);

    try {
      final reportsResponse = await _reportRepository.GetReports();

      if (reportsResponse is! SuccessResponseModel<List<Report>>) {
        throw Exception('Não foi possível carregar as denúncias.');
      }

      final categoriesResponse = await _categoryRepository.getCategories();

      final categories = <String, String>{};

      if (categoriesResponse.m_data != null) {
        for (final category in categoriesResponse.m_data!) {
          categories[category.id] = category.title;
        }
      }

      if (!mounted) return;

      setState(() {
        _reports = reportsResponse.m_data ?? [];
        _categories = categories;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void iniciarDenuncia() {
    setState(() {
      selecionandoLocal = true;
      localSelecionado = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Toque no mapa para selecionar o local da denúncia.'),
      ),
    );
  }

  void selecionarLocal(TapPosition tapPosition, LatLng ponto) {
    if (!selecionandoLocal) return;

    setState(() {
      localSelecionado = ponto;
    });
  }

  void cancelarDenuncia() {
    setState(() {
      selecionandoLocal = false;
      localSelecionado = null;
    });
  }

  Future<void> _openReport(Report report) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDetails(
          report: report,
          categoryTitle: _categories[report.reportCategoryId] ?? 'Categoria',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cidade Limpa'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          if (!selecionandoLocal)
            TextButton.icon(
              onPressed: iniciarDenuncia,
              icon: const Icon(Icons.add_location_alt, color: Colors.white),
              label: const Text(
                'Adicionar',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            IconButton(
              onPressed: cancelarDenuncia,
              icon: const Icon(Icons.close),
              tooltip: 'Cancelar denúncia',
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(-23.5228, -46.1883),
              initialZoom: 13,
              onTap: selecionarLocal,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'br.com.cidadelimpa.app',
              ),

              MarkerLayer(
                markers: [
                  ..._reports.map((report) {
                    return Marker(
                      point: LatLng(report.latitude, report.longitude),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () => _openReport(report),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 45,
                        ),
                      ),
                    );
                  }),

                  if (localSelecionado != null)
                    Marker(
                      point: localSelecionado!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),
                ],
              ),

              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          if (selecionandoLocal)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    localSelecionado == null
                        ? 'Toque no mapa para marcar o local do descarte irregular.'
                        : 'Local selecionado! Você pode alterar tocando em outro ponto.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          if (localSelecionado != null)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final ponto = localSelecionado!;

                  final created = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportForm(location: ponto),
                    ),
                  );

                  if (created == true && mounted) {
                    setState(() {
                      selecionandoLocal = false;
                      localSelecionado = null;
                    });

                    await _loadReports();
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Confirmar localização'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

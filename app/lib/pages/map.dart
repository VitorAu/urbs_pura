
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
  bool selecionandoLocal = false;
  LatLng? localSelecionado;

  void iniciarDenuncia() {
    setState(() {
      selecionandoLocal = true;
      localSelecionado = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Toque no mapa para selecionar o local da denúncia.',
        ),
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
              icon: const Icon(
                Icons.add_location_alt,
                color: Colors.white,
              ),
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
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'br.com.cidadelimpa.app',
              ),

              if (localSelecionado != null)
                MarkerLayer(
                  markers: [
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
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                  ),
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
                onPressed: () {
  final ponto = localSelecionado!;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ReportForm(
        location: ponto,
      ),
    ),
  );
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

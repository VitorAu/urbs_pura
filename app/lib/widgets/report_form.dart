import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import 'package:app/models/report_category.dart';
import 'package:app/repositories/report_category.dart';

import 'package:app/repositories/report.dart';
import 'package:app/models/response/success.dart';
import 'package:app/models/response/error.dart';
import 'package:app/repositories/report_media.dart';

class ReportForm extends StatefulWidget {
  final LatLng location;

  const ReportForm({super.key, required this.location});

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final ReportRepository _reportRepository = ReportRepository();
  bool _sendingReport = false;
  final ReportMediaRepository _reportMediaRepository = ReportMediaRepository();

  String? _createdReportId;
  String? _uploadUrl;
  bool _uploadCompleted = false;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _selectedCategory;
  XFile? _selectedImage;
  bool _loadingImage = false;

  final ReportCategoryRepository _categoryRepository =
      ReportCategoryRepository();

  List<ReportCategoryModel> _categories = [];
  bool _loadingCategories = true;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final response = await _categoryRepository.getCategories();

      if (!mounted) return;

      setState(() {
        _categories = response.m_data ?? [];
        _loadingCategories = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _categoryError = 'Não foi possível carregar as categorias.';
        _loadingCategories = false;
      });

      debugPrint('Erro ao carregar categorias: $error');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _loadingImage = true);

    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1600,
      );

      if (!mounted) return;

      if (image != null) {
        setState(() => _selectedImage = image);
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar imagem: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingImage = false);
      }
    }
  }

  void _showImageOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar fotografia'),
                onTap: () async {
                  Navigator.pop(sheetContext);

                  // Aguarda o fechamento do menu antes de abrir a câmera.
                  await Future<void>.delayed(const Duration(milliseconds: 300));

                  if (!mounted) return;

                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da galeria'),
                onTap: () async {
                  Navigator.pop(sheetContext);

                  await Future<void>.delayed(const Duration(milliseconds: 300));

                  if (!mounted) return;

                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _validateReport() async {
    if (_sendingReport || _uploadCompleted) return;

    if (!_formKey.currentState!.validate()) return;

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione uma fotografia da ocorrência.')),
      );
      return;
    }

    final categoryId = _selectedCategory;
    if (categoryId == null) return;

    setState(() => _sendingReport = true);

    try {
      // ETAPA 1: Criar a denúncia somente uma vez.
      if (_createdReportId == null) {
        final response = await _reportRepository.createReport(
          categoryId: categoryId,
          description: _descriptionController.text.trim(),
          latitude: widget.location.latitude,
          longitude: widget.location.longitude,
        );

        if (!mounted) return;

        if (response is ErrorResponseModel) {
          throw Exception(response.m_message);
        }

        if (response is! SuccessResponseModel) {
          throw Exception('Resposta inesperada ao criar denúncia.');
        }

        final data = response.m_data as Map<String, dynamic>?;
        final reportId = data?['id'] as String?;

        if (reportId == null || reportId.isEmpty) {
          throw Exception('A API não retornou o ID da denúncia.');
        }

        _createdReportId = reportId;
        debugPrint('Denúncia criada: $_createdReportId');
      }

      // ETAPA 2: Registrar a fotografia na API.
      // Não registra novamente se já recebeu a URL.
      if (_uploadUrl == null) {
        final mediaResponse = await _reportMediaRepository.createReportMedia(
          reportId: _createdReportId!,
        );

        if (!mounted) return;

        if (mediaResponse is ErrorResponseModel) {
          throw Exception(mediaResponse.m_message);
        }

        if (mediaResponse is! SuccessResponseModel) {
          throw Exception('Resposta inesperada ao registrar fotografia.');
        }

        final mediaData = mediaResponse.m_data as Map<String, dynamic>?;

        final uploadUrl = mediaData?['upload_url'] as String?;

        if (uploadUrl == null || uploadUrl.isEmpty) {
          throw Exception('A API não retornou a URL de upload.');
        }

        _uploadUrl = uploadUrl;
      }

      // ETAPA 3: Enviar a fotografia ao SeaweedFS.
      await _reportMediaRepository.uploadImage(
        uploadUrl: _uploadUrl!,
        imagePath: _selectedImage!.path,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      debugPrint('Erro no envio da denúncia: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Falha no envio: $error. Verifique antes de tentar novamente.',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 6),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sendingReport = false);
      }
    }
  }

  Future<void> _showCreateCategoryDialog() async {
  final category = await showDialog<ReportCategoryModel>(
    context: context,
    builder: (context) => CreateCategoryDialog(
      repository: _categoryRepository,
    ),
  );

  if (!mounted || category == null) return;

  setState(() {
    _categories.add(category);
    _selectedCategory = category.id;
  });
}

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova denúncia'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Registrar descarte irregular',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              if (_loadingCategories)
                const Center(child: CircularProgressIndicator())
              else ...[
                if (_categoryError != null)
                  Text(
                    _categoryError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: 'CREATE',
                      child: Text('+ Criar categoria'),
                    ),
                    ..._categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.title),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    if (value == 'CREATE') {
                      _showCreateCategoryDialog();
                      return;
                    }

                    setState(() => _selectedCategory = value);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione uma categoria';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 20),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                maxLength: 1000,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descreva o descarte irregular...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe uma descrição';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: _loadingImage ? null : _showImageOptions,
                icon: const Icon(Icons.add_a_photo),
                label: Text(
                  _selectedImage == null
                      ? 'Adicionar fotografia'
                      : 'Alterar fotografia',
                ),
              ),

              if (_loadingImage)
                const Center(child: CircularProgressIndicator()),

              if (_selectedImage != null) ...[
                const SizedBox(height: 12),
                Image.file(
                  File(_selectedImage!.path),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ],

              const SizedBox(height: 20),

              const Text(
                'Localização da ocorrência',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Text('Latitude: ${widget.location.latitude.toStringAsFixed(6)}'),
              Text(
                'Longitude: ${widget.location.longitude.toStringAsFixed(6)}',
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: (_loadingImage || _sendingReport)
                    ? null
                    : _validateReport,
                icon: const Icon(Icons.send),
                label: Text(_sendingReport ? 'Enviando...' : 'Enviar denúncia'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateCategoryDialog extends StatefulWidget {
  final ReportCategoryRepository repository;

  const CreateCategoryDialog({
    super.key,
    required this.repository,
  });

  @override
  State<CreateCategoryDialog> createState() =>
      _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  bool _creating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _createCategory() async {
    final title = _controller.text.trim();

    if (title.isEmpty || _creating) return;

    setState(() => _creating = true);

    try {
      final response = await widget.repository.createCategory(
        title: title,
      );

      if (!mounted) return;

      final category = response.m_data as ReportCategoryModel;

      Navigator.pop(context, category);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar categoria: $error')),
      );

      setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Criar categoria'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Nome da categoria',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _creating ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _creating ? null : _createCategory,
          child: Text(_creating ? 'Criando...' : 'Criar'),
        ),
      ],
    );
  }
}

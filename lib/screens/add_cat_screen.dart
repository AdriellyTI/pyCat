import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/cat.dart';

class AddCatScreen extends StatefulWidget {
  const AddCatScreen({super.key});

  @override
  State<AddCatScreen> createState() => _AddCatScreenState();
}

class _AddCatScreenState extends State<AddCatScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _breedController = TextEditingController();
  final List<String> _vaccines = [];
  final _vaccineController = TextEditingController();
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _birthdayController.dispose();
    _breedController.dispose();
    _vaccineController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _addVaccine() {
    final text = _vaccineController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _vaccines.add(text);
        _vaccineController.clear();
      });
    }
  }

  void _saveCat() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o nome do gato')),
      );
      return;
    }

    final cat = Cat(
      name: _nameController.text.trim(),
      ageYears: int.tryParse(_ageController.text.trim()) ?? 0,
      imageUrl: _selectedImage?.path,
      birthday: _birthdayController.text.trim().isNotEmpty
          ? _birthdayController.text.trim()
          : null,
      breed: _breedController.text.trim().isNotEmpty
          ? _breedController.text.trim()
          : null,
      vaccines: List.from(_vaccines),
    );

    Navigator.pop(context, cat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Adicionar Gato',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo upload
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? Icon(Icons.pets, size: 48, color: Colors.grey[500])
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black54, width: 1.5),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.add, size: 20, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),

            // Name
            const Text('Nome do gato:', style: TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 6),
            _buildTextField(_nameController),
            const SizedBox(height: 16),

            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Aniversário:', style: TextStyle(fontSize: 14, color: Colors.black87)),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            _birthdayController.text =
                                '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                          }
                        },
                        child: AbsorbPointer(
                          child: _buildTextField(_birthdayController, hint: 'dd/mm/aaaa'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Breed
            const Text('Raça:', style: TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 6),
            SizedBox(
              width: 180,
              child: _buildTextField(_breedController),
            ),
            const SizedBox(height: 24),

            // Vaccines
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black54),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _addVaccine,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: Colors.black87),
                        SizedBox(width: 4),
                        Text(
                          'Vacinas:',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  if (_vaccines.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ..._vaccines.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '• ${entry.value}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _vaccines.removeAt(entry.key);
                                });
                              },
                              child: const Icon(Icons.close, size: 16, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _vaccineController,
                          decoration: const InputDecoration(
                            hintText: 'Nome da vacina',
                            isDense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 13),
                          onSubmitted: (_) => _addVaccine(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.check, size: 20),
                        onPressed: _addVaccine,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveCat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5985CB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black54),
        ),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }
}

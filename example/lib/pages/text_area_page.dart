import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class TextAreaPage extends StatefulWidget {
  const TextAreaPage({super.key});

  @override
  State<TextAreaPage> createState() => _TextAreaPageState();
}

class _TextAreaPageState extends State<TextAreaPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakTextArea')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Multi-line text area for longer content.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Supports label, required indicator, error, min/max lines, and max length.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            YakTextArea(
              label: 'Address',
              isRequired: true,
              placeholder: 'Enter your full address',
              controller: _addressController,
              minLines: 4,
              onChanged: (_) {},
            ),
            const SizedBox(height: 24),
            YakTextArea(
              label: 'Notes',
              placeholder: 'Additional notes (optional)',
              controller: _notesController,
              minLines: 3,
              maxLength: 500,
              onChanged: (_) {},
            ),
            const SizedBox(height: 24),
            YakTextArea(
              label: 'Description',
              placeholder: 'Enter description',
              errorMessage: 'Description is required',
              minLines: 4,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}

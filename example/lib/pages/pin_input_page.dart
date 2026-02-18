import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class PinInputPage extends StatefulWidget {
  const PinInputPage({super.key});

  @override
  State<PinInputPage> createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  String _pinCode = '';
  bool _showError = true;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakPinInput')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PIN input: current digit visible, previous as dots (•)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Only the focused box shows the actual number; filled boxes show a dot. Gold border on the active box.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            const Text(
              '6-digit PIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            YakPinInput(
              length: 6,
              boxSize: 48,
              spacing: 12,
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              onChanged: (code) => setState(() => _pinCode = code),
              onCompleted: (code) => _showSnackBar('PIN completed: $code'),
            ),
            if (_pinCode.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Current code: $_pinCode',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Error state',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () => setState(() => _showError = !_showError),
                  child: Text(_showError ? 'Hide error' : 'Show error'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            YakPinInput(
              length: 6,
              errorMessage: _showError
                  ? 'รหัสยืนยันตัวตนไม่ถูกต้อง โปรดลองอีกครั้ง'
                  : null,
              boxSize: 48,
              spacing: 12,
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              onCompleted: (code) => _showSnackBar('PIN completed: $code'),
            ),
            const SizedBox(height: 32),
            const Text(
              '4-digit PIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            YakPinInput(
              length: 4,
              boxSize: 56,
              spacing: 16,
              onCompleted: (code) => _showSnackBar('PIN completed: $code'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Custom size and spacing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            YakPinInput(
              length: 6,
              boxSize: 56,
              spacing: 20,
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              onCompleted: (code) => _showSnackBar('PIN completed: $code'),
            ),
          ],
        ),
      ),
    );
  }
}

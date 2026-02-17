import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class OtpInputPage extends StatefulWidget {
  const OtpInputPage({super.key});

  @override
  State<OtpInputPage> createState() => _OtpInputPageState();
}

class _OtpInputPageState extends State<OtpInputPage> {
  String _otpCode = '';
  bool _showError = true;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakOtpInput')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'OTP / PIN input with multiple digit boxes.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Configurable length, box size, spacing, and obscure text.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            const Text('6-digit OTP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            YakOtpInput(
              length: 6,
              boxSize: 48,
              spacing: 12,
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              onChanged: (code) => setState(() => _otpCode = code),
              onCompleted: (code) => _showSnackBar('OTP completed: $code'),
            ),
            if (_otpCode.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Current code: $_otpCode', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
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
            YakOtpInput(
              length: 6,
              errorMessage: _showError ? 'รหัสยืนยันตัวตนไม่ถูกต้อง โปรดลองอีกครั้ง' : null,
              boxSize: 48,
              spacing: 12,
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              onCompleted: (code) => _showSnackBar('OTP completed: $code'),
            ),
            const SizedBox(height: 32),
            const Text('4-digit PIN (obscured)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            YakOtpInput(
              length: 4,
              boxSize: 56,
              spacing: 16,
              obscureText: true,
              onCompleted: (code) => _showSnackBar('PIN completed: $code'),
            ),
          ],
        ),
      ),
    );
  }
}

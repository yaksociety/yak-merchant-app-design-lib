import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class ToggleButtonPage extends StatefulWidget {
  const ToggleButtonPage({super.key});

  @override
  State<ToggleButtonPage> createState() => _ToggleButtonPageState();
}

class _ToggleButtonPageState extends State<ToggleButtonPage> {
  bool _enabled = false;
  bool _optionA = true;
  bool _optionB = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakToggleButton')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Toggle switch for on/off states.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Used to switch between two states or options.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                YakToggleButton(
                  value: _enabled,
                  onChanged: (value) {
                    setState(() => _enabled = value);
                    _showSnackBar('Toggle: ${value ? 'ON' : 'OFF'}');
                  },
                ),
                const SizedBox(width: 16),
                Text(_enabled ? 'Enabled' : 'Disabled', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Multiple toggles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                YakToggleButton(
                  value: _optionA,
                  onChanged: (value) => setState(() => _optionA = value),
                ),
                const SizedBox(width: 12),
                const Text('Option A', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                YakToggleButton(
                  value: _optionB,
                  onChanged: (value) => setState(() => _optionB = value),
                ),
                const SizedBox(width: 12),
                const Text('Option B', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Disabled', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                YakToggleButton(value: true, onChanged: null),
                const SizedBox(width: 12),
                Text('Disabled (on)', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                YakToggleButton(value: false, onChanged: null),
                const SizedBox(width: 12),
                Text('Disabled (off)', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

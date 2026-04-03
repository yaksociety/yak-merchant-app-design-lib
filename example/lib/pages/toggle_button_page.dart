import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class ToggleButtonPage extends StatefulWidget {
  const ToggleButtonPage({super.key});

  @override
  State<ToggleButtonPage> createState() => _ToggleButtonPageState();
}

class _ToggleButtonPageState extends State<ToggleButtonPage> {
  bool _main = false;
  bool _optionA = true;
  bool _optionB = false;
  bool _customTracks = false;
  bool _customThumbs = false;
  bool _bareSwitch = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSection(
    String title,
    String description,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
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
            _buildSection(
              'With label',
              'Tap the switch or the label (and the space to the right) to toggle.',
              [
                YakToggleButton(
                  value: _main,
                  label: 'Push notifications',
                  labelSpacing: 16,
                  onChanged: (value) {
                    setState(() => _main = value);
                    _showSnackBar(value ? 'Notifications on' : 'Notifications off');
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Multiple toggles',
              'Independent rows; each label is part of its control.',
              [
                YakToggleButton(
                  value: _optionA,
                  label: 'Option A',
                  onChanged: (value) => setState(() => _optionA = value),
                ),
                const SizedBox(height: 12),
                YakToggleButton(
                  value: _optionB,
                  label: 'Option B',
                  onChanged: (value) => setState(() => _optionB = value),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Custom colors',
              'Use color / activeColor / inactiveColor for tracks; '
                  'activeThumbColor / inactiveThumbColor for the knob.',
              [
                YakToggleButton(
                  value: _customTracks,
                  label: 'Primary track on, neutral off',
                  onChanged: (value) => setState(() => _customTracks = value),
                  color: YakColor.semantic.textAndIcons.primary,
                  inactiveColor: YakColor.primitive.neutral.neutral500,
                ),
                const SizedBox(height: 12),
                YakToggleButton(
                  value: _customThumbs,
                  label: 'Amber thumbs on green / gray tracks',
                  onChanged: (value) => setState(() => _customThumbs = value),
                  activeColor: YakColor.semantic.textAndIcons.success,
                  inactiveColor: YakColor.primitive.neutral.neutral600,
                  activeThumbColor: YakColor.primitive.primary.primary400,
                  inactiveThumbColor: YakColor.primitive.primary.primary200,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Switch only (no label)',
              'Omit label when you only need the switch, or place your own widget beside it.',
              [
                Row(
                  children: [
                    YakToggleButton(
                      value: _bareSwitch,
                      onChanged: (value) => setState(() => _bareSwitch = value),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Plain switch; tap target is the control only.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Disabled',
              'onChanged: null grays out the control and removes taps.',
              [
                YakToggleButton(
                  value: true,
                  onChanged: null,
                  label: 'Disabled (on)',
                ),
                const SizedBox(height: 12),
                YakToggleButton(
                  value: false,
                  onChanged: null,
                  label: 'Disabled (off)',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

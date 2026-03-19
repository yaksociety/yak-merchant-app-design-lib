import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  String _sizeS = 'M';
  String _sizeM = 'M';
  String _sizeL = 'M';
  String _customColor = 'selected';

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
      appBar: AppBar(title: const Text('YakRadioButton')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Styles (S / M / L)',
              'Preview sizes and focus glow. Try tab/keyboard focus on each row.',
              [
                const Text(
                  'Small (S)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                YakRadioGroup<String>(
                  groupValue: _sizeS,
                  onChanged: (v) => setState(() => _sizeS = v ?? 'M'),
                  children: const [
                    YakRadioButton<String>(
                      value: 'S',
                      label: 'S',
                      size: YakRadioSize.s,
                    ),
                    YakRadioButton<String>(
                      value: 'M',
                      label: 'M',
                      size: YakRadioSize.s,
                    ),
                    YakRadioButton<String>(
                      value: 'L',
                      label: 'L',
                      size: YakRadioSize.s,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Medium (M)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                YakRadioGroup<String>(
                  groupValue: _sizeM,
                  onChanged: (v) => setState(() => _sizeM = v ?? 'M'),
                  children: const [
                    YakRadioButton<String>(
                      value: 'S',
                      label: 'S',
                      size: YakRadioSize.m,
                    ),
                    YakRadioButton<String>(
                      value: 'M',
                      label: 'M',
                      size: YakRadioSize.m,
                    ),
                    YakRadioButton<String>(
                      value: 'L',
                      label: 'L',
                      size: YakRadioSize.m,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Large (L)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                YakRadioGroup<String>(
                  groupValue: _sizeL,
                  onChanged: (v) => setState(() => _sizeL = v ?? 'M'),
                  children: const [
                    YakRadioButton<String>(
                      value: 'S',
                      label: 'S',
                      size: YakRadioSize.l,
                    ),
                    YakRadioButton<String>(
                      value: 'M',
                      label: 'M',
                      size: YakRadioSize.l,
                    ),
                    YakRadioButton<String>(
                      value: 'L',
                      label: 'L',
                      size: YakRadioSize.l,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Custom colors',
              'Change main color and dot color.',
              [
                YakRadioGroup<String>(
                  groupValue: _customColor,
                  onChanged: (v) => setState(() => _customColor = v ?? 'selected'),
                  children: [
                    YakRadioButton<String>(
                      value: 'selected',
                      label: 'Default (semantic primary + white dot)',
                      color: YakColor.semantic.textAndIcons.primary,
                      checkColor: YakColor.semantic.textAndIcons.onColor,
                    ),
                    YakRadioButton<String>(
                      value: 'success',
                      label: 'Success (green) + black dot',
                      color: YakColor.semantic.textAndIcons.success,
                      checkColor: YakColor.primitive.base.black,
                    ),
                    YakRadioButton<String>(
                      value: 'danger',
                      label: 'Danger (red) + white dot',
                      color: YakColor.semantic.textAndIcons.danger,
                      checkColor: YakColor.semantic.textAndIcons.onColor,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Disabled',
              'Shows disabled styles and prevents selection.',
              [
                YakRadioButton<String>(
                  value: 'disabled-1',
                  groupValue: 'disabled-1',
                  onChanged: null,
                  label: 'Disabled (selected)',
                  subtitle: 'Cannot change selection',
                ),
                YakRadioButton<String>(
                  value: 'disabled-2',
                  groupValue: 'disabled-1',
                  onChanged: null,
                  label: 'Disabled (unselected)',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

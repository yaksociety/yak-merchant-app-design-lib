import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key});

  @override
  State<CheckboxPage> createState() => _CheckboxPageState();
}

class _CheckboxPageState extends State<CheckboxPage> {
  bool _strokeCircleS = true;
  bool _strokeCircleM = true;
  bool _strokeCircleL = true;

  bool _fillSquareS = true;
  bool _fillSquareM = true;
  bool _fillSquareL = true;

  bool _custom = true;

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
      appBar: AppBar(title: const Text('YakCheckboxButton')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Stroke • Circle (S / M / L)',
              'Outline + check (no fill). Try focus (tab/keyboard) to see glow.',
              [
                YakCheckboxButton(
                  value: _strokeCircleS,
                  onChanged: (v) => setState(() => _strokeCircleS = v),
                  label: 'Small (S)',
                  size: YakCheckboxSize.s,
                  shape: YakCheckboxShape.circle,
                  variant: YakCheckboxVariant.stroke,
                ),
                YakCheckboxButton(
                  value: _strokeCircleM,
                  onChanged: (v) => setState(() => _strokeCircleM = v),
                  label: 'Medium (M)',
                  size: YakCheckboxSize.m,
                  shape: YakCheckboxShape.circle,
                  variant: YakCheckboxVariant.stroke,
                ),
                YakCheckboxButton(
                  value: _strokeCircleL,
                  onChanged: (v) => setState(() => _strokeCircleL = v),
                  label: 'Large (L)',
                  size: YakCheckboxSize.l,
                  shape: YakCheckboxShape.circle,
                  variant: YakCheckboxVariant.stroke,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Fill • Rounded square (S / M / L)',
              'Filled background + check.',
              [
                YakCheckboxButton(
                  value: _fillSquareS,
                  onChanged: (v) => setState(() => _fillSquareS = v),
                  label: 'Small (S)',
                  size: YakCheckboxSize.s,
                  shape: YakCheckboxShape.roundedSquare,
                  variant: YakCheckboxVariant.fill,
                ),
                YakCheckboxButton(
                  value: _fillSquareM,
                  onChanged: (v) => setState(() => _fillSquareM = v),
                  label: 'Medium (M)',
                  size: YakCheckboxSize.m,
                  shape: YakCheckboxShape.roundedSquare,
                  variant: YakCheckboxVariant.fill,
                ),
                YakCheckboxButton(
                  value: _fillSquareL,
                  onChanged: (v) => setState(() => _fillSquareL = v),
                  label: 'Large (L)',
                  size: YakCheckboxSize.l,
                  shape: YakCheckboxShape.roundedSquare,
                  variant: YakCheckboxVariant.fill,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Disabled',
              'Muted styles and non-interactive when onChanged is null.',
              [
                const YakCheckboxButton(
                  value: true,
                  onChanged: null,
                  label: 'Disabled (checked)',
                  size: YakCheckboxSize.m,
                  shape: YakCheckboxShape.circle,
                  variant: YakCheckboxVariant.stroke,
                ),
                const YakCheckboxButton(
                  value: false,
                  onChanged: null,
                  label: 'Disabled (unchecked)',
                  size: YakCheckboxSize.m,
                  shape: YakCheckboxShape.roundedSquare,
                  variant: YakCheckboxVariant.fill,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Custom colors',
              'Change main color and check color.',
              [
                YakCheckboxButton(
                  value: _custom,
                  onChanged: (v) => setState(() => _custom = v),
                  label: 'Success (green) + black check',
                  subtitle: 'color + checkColor override',
                  color: YakColor.semantic.textAndIcons.success,
                  checkColor: YakColor.primitive.base.black,
                  shape: YakCheckboxShape.circle,
                  variant: YakCheckboxVariant.fill,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

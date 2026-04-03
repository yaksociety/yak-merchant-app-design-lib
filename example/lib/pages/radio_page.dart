import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  /// Spec grid: one radio per column (S / M / L control sizes).
  int _sizeRefColumn = 1;

  String _sizeS = 'b';
  String _sizeM = 'b';
  String _sizeL = 'b';
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
              'Circle sizes (spec)',
              'S: 16px outline, 8px inner dot · M: 20px / 12px · L: 22px / 14px. '
                  'Matches design tokens; use tab focus to see glow.',
              [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'S',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'M',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'L',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                YakRadioGroup<int>(
                  groupValue: _sizeRefColumn,
                  onChanged: (v) =>
                      setState(() => _sizeRefColumn = v ?? 1),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: 48,
                              child: YakRadioButton<int>(
                                value: 0,
                                label: '',
                                size: YakRadioSize.s,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: 48,
                              child: YakRadioButton<int>(
                                value: 1,
                                label: '',
                                size: YakRadioSize.m,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: 48,
                              child: YakRadioButton<int>(
                                value: 2,
                                label: '',
                                size: YakRadioSize.l,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Same options, different control sizes',
              'Each group uses Option A / B / C only the YakRadioSize changes (S, M, or L).',
              [
                const Text(
                  'YakRadioSize.s',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                YakRadioGroup<String>(
                  groupValue: _sizeS,
                  onChanged: (v) => setState(() => _sizeS = v ?? 'b'),
                  children: const [
                    YakRadioButton<String>(
                      value: 'a',
                      label: 'Option A',
                      size: YakRadioSize.s,
                    ),
                    YakRadioButton<String>(
                      value: 'b',
                      label: 'Option B',
                      size: YakRadioSize.s,
                    ),
                    YakRadioButton<String>(
                      value: 'c',
                      label: 'Option C',
                      size: YakRadioSize.s,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'YakRadioSize.m',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                YakRadioGroup<String>(
                  groupValue: _sizeM,
                  onChanged: (v) => setState(() => _sizeM = v ?? 'b'),
                  children: const [
                    YakRadioButton<String>(
                      value: 'a',
                      label: 'Option A',
                      size: YakRadioSize.m,
                    ),
                    YakRadioButton<String>(
                      value: 'b',
                      label: 'Option B',
                      size: YakRadioSize.m,
                    ),
                    YakRadioButton<String>(
                      value: 'c',
                      label: 'Option C',
                      size: YakRadioSize.m,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'YakRadioSize.l',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                YakRadioGroup<String>(
                  groupValue: _sizeL,
                  onChanged: (v) => setState(() => _sizeL = v ?? 'b'),
                  children: const [
                    YakRadioButton<String>(
                      value: 'a',
                      label: 'Option A',
                      size: YakRadioSize.l,
                    ),
                    YakRadioButton<String>(
                      value: 'b',
                      label: 'Option B',
                      size: YakRadioSize.l,
                    ),
                    YakRadioButton<String>(
                      value: 'c',
                      label: 'Option C',
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

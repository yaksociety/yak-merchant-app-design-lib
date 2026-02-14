import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  String? _taxConfirm = 'yes';
  String? _deliveryMethod = 'standard';
  String? _paymentMethod;
  String _size = 'M';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
      appBar: AppBar(title: const Text('YakRadioButton')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'With helper text (config like design)',
              'Each YakRadioButton can have its own helperText below that option. Layout: Yes, then No with grey helper under it.',
              [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: YakRadioGroup<String>(
                    groupValue: _taxConfirm,
                    onChanged: (v) => setState(() => _taxConfirm = v),
                    children: [
                      YakRadioButton<String>(value: 'yes', label: 'ใช่'),
                      YakRadioButton<String>(
                        value: 'no',
                        label: 'ไม่ใช่',
                        helperText:
                            'กรณีมีรายได้ไม่เกิน 1.8 ล้านบาทต่อปี หรือได้รับการยกเว้นภาษี '
                            'โปรดระบุในหนังสือรับรองการจดทะเบียนบริษัท',
                        helperStyle: YakTypography.semantic.textS.regular
                            .copyWith(
                              color: YakColor.semantic.textAndIcons.baseSecond,
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Delivery method',
              'Single choice: standard, express, or pickup.',
              [
                YakRadioButton<String>(
                  value: 'standard',
                  groupValue: _deliveryMethod,
                  onChanged: (v) {
                    setState(() => _deliveryMethod = v);
                    _showSnackBar('Delivery: $v');
                  },
                  label: 'Standard (3–5 days)',
                ),
                YakRadioButton<String>(
                  value: 'express',
                  groupValue: _deliveryMethod,
                  onChanged: (v) {
                    setState(() => _deliveryMethod = v);
                    _showSnackBar('Delivery: $v');
                  },
                  label: 'Express (1–2 days)',
                ),
                YakRadioButton<String>(
                  value: 'pickup',
                  groupValue: _deliveryMethod,
                  onChanged: (v) {
                    setState(() => _deliveryMethod = v);
                    _showSnackBar('Delivery: $v');
                  },
                  label: 'Store pickup',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Payment method',
              'With optional subtitles for extra info.',
              [
                YakRadioButton<String>(
                  value: 'card',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v),
                  label: 'Card',
                  subtitle: 'Visa, Mastercard, or Amex',
                ),
                YakRadioButton<String>(
                  value: 'bank',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v),
                  label: 'Bank transfer',
                  subtitle: 'Pay within 24 hours',
                ),
                YakRadioButton<String>(
                  value: 'cash',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v),
                  label: 'Cash on delivery',
                  subtitle: 'Pay when you receive',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection('Size', 'Simple options (S / M / L).', [
              YakRadioButton<String>(
                value: 'S',
                groupValue: _size,
                onChanged: (v) => setState(() => _size = v ?? 'M'),
                label: 'S',
              ),
              YakRadioButton<String>(
                value: 'M',
                groupValue: _size,
                onChanged: (v) => setState(() => _size = v ?? 'M'),
                label: 'M',
              ),
              YakRadioButton<String>(
                value: 'L',
                groupValue: _size,
                onChanged: (v) => setState(() => _size = v ?? 'M'),
                label: 'L',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

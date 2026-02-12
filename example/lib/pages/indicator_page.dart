import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class IndicatorPage extends StatefulWidget {
  const IndicatorPage({super.key});

  @override
  State<IndicatorPage> createState() => _IndicatorPageState();
}

class _IndicatorPageState extends State<IndicatorPage> {
  double _value = 0.25;
  bool _showLabel = false;
  double _radius = 6; // half of default height 12

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakIndicator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress indicator with rounded ends and smooth animation.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Set [indicatorRadius] for roundness; value changes animate smoothly.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            const Text('Static steps (0%, 25%, 50%, 75%, 100%)',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...[0.0, 0.25, 0.5, 0.75, 1.0].map((v) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: YakIndicator(
                    value: v,
                    height: 12,
                    indicatorRadius: 6,
                    showLabel: true,
                  ),
                )),
            const SizedBox(height: 24),
            const Text('Custom radius (more rounded)',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            YakIndicator(
              value: 0.6,
              height: 16,
              indicatorRadius: 10,
            ),
            const SizedBox(height: 24),
            const Text('Interactive (drag slider)',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            YakIndicator(
              value: _value,
              height: 12,
              indicatorRadius: _radius,
              showLabel: _showLabel,
            ),
            const SizedBox(height: 16),
            Slider(
              value: _value,
              onChanged: (v) => setState(() => _value = v),
            ),
            Text('Value: ${(_value * 100).round()}%'),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Show percentage label'),
              value: _showLabel,
              onChanged: (v) => setState(() => _showLabel = v),
            ),
            const SizedBox(height: 8),
            Text('Indicator radius: ${_radius.toStringAsFixed(0)}'),
            Slider(
              value: _radius,
              min: 2,
              max: 12,
              onChanged: (v) => setState(() => _radius = v),
            ),
          ],
        ),
      ),
    );
  }
}

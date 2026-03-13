import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class DateInputPage extends StatefulWidget {
  const DateInputPage({super.key});

  @override
  State<DateInputPage> createState() => _DateInputPageState();
}

class _DateInputPageState extends State<DateInputPage> {
  DateTime? _selectedDate;
  DateTime? _prefilledDate = DateTime(1999, 1, 1);

  Widget _section(String title, String subtitle, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakDateInput')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date input field with calendar icon.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to open a calendar picker (wired separately). Shows DD/MM/YYYY format.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            _section(
              'Empty (placeholder)',
              'No date selected — shows placeholder text.',
              [
                YakDateInput(
                  label: 'วัน/เดือน/ปีเกิด',
                  isRequired: true,
                  placeholder: 'DD/MM/YYYY',
                  value: _selectedDate,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(1999, 1, 1),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            _section(
              'Pre-filled date',
              'Date already selected — shows formatted value.',
              [
                YakDateInput(
                  label: 'วัน/เดือน/ปีเกิด',
                  isRequired: true,
                  value: _prefilledDate,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _prefilledDate ?? DateTime(1999, 1, 1),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _prefilledDate = picked);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            _section(
              'With error',
              'Error message and danger-colored label.',
              [
                YakDateInput(
                  label: 'วัน/เดือน/ปีเกิด',
                  isRequired: true,
                  value: null,
                  errorMessage: 'กรุณาเลือกวันเกิด',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            _section(
              'Disabled',
              'Grey background, no interaction.',
              [
                YakDateInput(
                  label: 'วัน/เดือน/ปีเกิด',
                  value: DateTime(1999, 1, 1),
                  enabled: false,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _section(
              'No label',
              'Date input without a label.',
              [
                YakDateInput(
                  value: DateTime(2000, 6, 15),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

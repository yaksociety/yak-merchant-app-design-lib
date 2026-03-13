import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({super.key});

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  DateTime? _calendarSingleDate;
  DateTimeRange? _calendarRange;
  DateTime? _wheelDate;
  DateTime? _inputDate;

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

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Date Pickers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calendar & wheel date pickers.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'YakCalendarPicker for grid-based selection (single & range), '
              'YakWheelDatePicker for scroll-wheel selection in a bottom sheet.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            // ---------------------------------------------------------------
            const SizedBox(height: 32),
            _section(
              'YakDateInput + Calendar',
              'Tap the date field to open the calendar picker dialog.',
              [
                YakDateInput(
                  label: 'วัน/เดือน/ปีเกิด',
                  isRequired: true,
                  value: _inputDate,
                  onTap: () async {
                    final picked = await showYakCalendarPicker(
                      context: context,
                      initialDate: _inputDate,
                      maxDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _inputDate = picked);
                    }
                  },
                ),
              ],
            ),

            // ---------------------------------------------------------------
            const SizedBox(height: 32),
            _section(
              'Calendar – single date (with period tabs)',
              'Shows optional Weekly / Monthly / Annual tabs.',
              [
                Text(
                  _calendarSingleDate != null
                      ? 'Selected: ${_fmt(_calendarSingleDate!)}'
                      : 'No date selected',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showYakCalendarPicker(
                      context: context,
                      initialDate: _calendarSingleDate,
                      periodTabs: const ['Weekly', 'Monthly', 'Annual'],
                    );
                    if (picked != null) {
                      setState(() => _calendarSingleDate = picked);
                    }
                  },
                  child: const Text('Open calendar (single)'),
                ),
              ],
            ),

            // ---------------------------------------------------------------
            const SizedBox(height: 32),
            _section(
              'Calendar – date range',
              'Tap two dates to form a range, then Continue.',
              [
                Text(
                  _calendarRange != null
                      ? 'Range: ${_fmt(_calendarRange!.start)} – ${_fmt(_calendarRange!.end)}'
                      : 'No range selected',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showYakCalendarRangePicker(
                      context: context,
                      initialStart: _calendarRange?.start,
                      initialEnd: _calendarRange?.end,
                      periodTabs: const ['Weekly', 'Monthly', 'Annual'],
                    );
                    if (picked != null) {
                      setState(() => _calendarRange = picked);
                    }
                  },
                  child: const Text('Open calendar (range)'),
                ),
              ],
            ),

            // ---------------------------------------------------------------
            const SizedBox(height: 32),
            _section(
              'Wheel date picker (bottom sheet)',
              'Three-column scroll wheel for Month / Day / Year.',
              [
                Text(
                  _wheelDate != null
                      ? 'Selected: ${_fmt(_wheelDate!)}'
                      : 'No date selected',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showYakWheelDatePicker(
                      context: context,
                      initialDate: _wheelDate ?? DateTime(2023, 5, 1),
                    );
                    if (picked != null) {
                      setState(() => _wheelDate = picked);
                    }
                  },
                  child: const Text('Open wheel picker'),
                ),
              ],
            ),

            // ---------------------------------------------------------------
            const SizedBox(height: 32),
            _section(
              'Inline calendar preview',
              'YakCalendarPicker embedded directly in the page.',
              [
                YakCalendarPicker(
                  mode: YakCalendarMode.single,
                  initialDate: DateTime.now(),
                  periodTabs: const ['Weekly', 'Monthly', 'Annual'],
                  continueLabel: 'Continue',
                  closeLabel: 'Close',
                  onClose: () {},
                  onConfirm: (date, _) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Confirmed: ${_fmt(date)}')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

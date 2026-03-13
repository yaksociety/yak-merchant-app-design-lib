import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

/// Shows a [YakWheelDatePicker] in a bottom modal sheet.
///
/// Returns the confirmed [DateTime], or `null` if dismissed.
Future<DateTime?> showYakWheelDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? minDate,
  DateTime? maxDate,
  List<String>? monthNames,
  String confirmLabel = 'Confirm',
}) {
  DateTime selected = initialDate ?? DateTime.now();

  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      decoration: BoxDecoration(
        color: YakColor.semantic.background.baseMain,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: YakColor.primitive.neutral.neutral700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            YakWheelDatePicker(
              initialDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
              monthNames: monthNames,
              onDateChanged: (date) => selected = date,
            ),
            // Confirm button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: GestureDetector(
                  onTap: () => Navigator.pop(ctx, selected),
                  child: Container(
                    decoration: BoxDecoration(
                      color: YakColor.primitive.primary.primary500,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      confirmLabel,
                      style: YakTypography.semantic.textS.semibold.copyWith(
                        color: YakColor.semantic.textAndIcons.baseMain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Wheel-style date picker for the Yak design system.
///
/// Displays three scrollable columns — Month, Day, Year — with a
/// selection highlight band across the center. Designed to be embedded
/// in a bottom sheet via [showYakWheelDatePicker] or used standalone.
class YakWheelDatePicker extends StatefulWidget {
  /// Initial date to scroll to. Defaults to today.
  final DateTime? initialDate;

  /// Minimum selectable date (determines min year).
  final DateTime? minDate;

  /// Maximum selectable date (determines max year).
  final DateTime? maxDate;

  /// Fired whenever the selected date changes during scroll.
  final ValueChanged<DateTime>? onDateChanged;

  /// Month names (length 12). Defaults to English names.
  final List<String>? monthNames;

  const YakWheelDatePicker({
    super.key,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.onDateChanged,
    this.monthNames,
  }) : assert(monthNames == null || monthNames.length == 12);

  @override
  State<YakWheelDatePicker> createState() => _YakWheelDatePickerState();
}

class _YakWheelDatePickerState extends State<YakWheelDatePicker> {
  late int _selectedMonth; // 1-12
  late int _selectedDay; // 1-31
  late int _selectedYear;

  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _yearController;

  static const List<String> _defaultMonthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  List<String> get _monthNames => widget.monthNames ?? _defaultMonthNames;
  int get _minYear => widget.minDate?.year ?? 1900;
  int get _maxYear => widget.maxDate?.year ?? 2100;

  static const double _itemExtent = 44;
  static const double _wheelHeight = 220;

  int _daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDate ?? DateTime.now();
    _selectedMonth = initial.month;
    _selectedDay = initial.day;
    _selectedYear = initial.year.clamp(_minYear, _maxYear);

    _monthController =
        FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _dayController =
        FixedExtentScrollController(initialItem: _selectedDay - 1);
    _yearController =
        FixedExtentScrollController(initialItem: _selectedYear - _minYear);
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _adjustDayIfNeeded() {
    final maxDay = _daysInMonth(_selectedYear, _selectedMonth);
    if (_selectedDay > maxDay) {
      _selectedDay = maxDay;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_dayController.hasClients) {
          _dayController.jumpToItem(_selectedDay - 1);
        }
      });
    }
  }

  void _notifyChanged() {
    widget.onDateChanged?.call(
      DateTime(_selectedYear, _selectedMonth, _selectedDay),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxDay = _daysInMonth(_selectedYear, _selectedMonth);
    final yearCount = _maxYear - _minYear + 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: SizedBox(
        height: _wheelHeight,
        child: Stack(
          children: [
            // Selection highlight band
            Center(
              child: Container(
                height: _itemExtent,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: YakColor.primitive.neutral.neutral700,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            // Three wheels
            Row(
              children: [
                // Month
                Expanded(
                  flex: 3,
                  child: ListWheelScrollView.useDelegate(
                    controller: _monthController,
                    itemExtent: _itemExtent,
                    perspective: 0.003,
                    diameterRatio: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedMonth = index + 1;
                        _adjustDayIfNeeded();
                      });
                      _notifyChanged();
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 12,
                      builder: (context, index) {
                        final isSelected = index == _selectedMonth - 1;
                        return Center(
                          child: Text(
                            _monthNames[index],
                            style: YakTypography.semantic.textM.regular
                                .copyWith(
                              color: isSelected
                                  ? YakColor.semantic.textAndIcons.baseMain
                                  : YakColor.semantic.textAndIcons.disabled,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Day
                Expanded(
                  flex: 2,
                  child: ListWheelScrollView.useDelegate(
                    controller: _dayController,
                    itemExtent: _itemExtent,
                    perspective: 0.003,
                    diameterRatio: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() => _selectedDay = index + 1);
                      _notifyChanged();
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: maxDay,
                      builder: (context, index) {
                        final isSelected = index == _selectedDay - 1;
                        return Center(
                          child: Text(
                            '${index + 1}',
                            style: YakTypography.semantic.textM.regular
                                .copyWith(
                              color: isSelected
                                  ? YakColor.semantic.textAndIcons.baseMain
                                  : YakColor.semantic.textAndIcons.disabled,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Year
                Expanded(
                  flex: 2,
                  child: ListWheelScrollView.useDelegate(
                    controller: _yearController,
                    itemExtent: _itemExtent,
                    perspective: 0.003,
                    diameterRatio: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedYear = _minYear + index;
                        _adjustDayIfNeeded();
                      });
                      _notifyChanged();
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: yearCount,
                      builder: (context, index) {
                        final year = _minYear + index;
                        final isSelected = year == _selectedYear;
                        return Center(
                          child: Text(
                            '$year',
                            style: YakTypography.semantic.textM.regular
                                .copyWith(
                              color: isSelected
                                  ? YakColor.semantic.textAndIcons.baseMain
                                  : YakColor.semantic.textAndIcons.disabled,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

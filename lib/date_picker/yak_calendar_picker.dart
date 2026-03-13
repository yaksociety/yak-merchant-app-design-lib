import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

/// Selection mode for [YakCalendarPicker].
enum YakCalendarMode {
  /// Select a single date.
  single,

  /// Select a date range (start and end).
  range,
}

/// Shows a [YakCalendarPicker] in a dialog and returns the selected date.
///
/// Returns `null` if the user closes without confirming.
Future<DateTime?> showYakCalendarPicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? minDate,
  DateTime? maxDate,
  List<String>? periodTabs,
  int initialTabIndex = 1,
  ValueChanged<int>? onTabChanged,
  String continueLabel = 'Continue',
  String closeLabel = 'Close',
  String Function(int year, int month)? headerBuilder,
  List<String>? monthNames,
  List<String>? dayLabels,
}) {
  return showDialog<DateTime>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: YakCalendarPicker(
        mode: YakCalendarMode.single,
        initialDate: initialDate,
        minDate: minDate,
        maxDate: maxDate,
        periodTabs: periodTabs,
        initialTabIndex: initialTabIndex,
        onTabChanged: onTabChanged,
        continueLabel: continueLabel,
        closeLabel: closeLabel,
        headerBuilder: headerBuilder,
        monthNames: monthNames,
        dayLabels: dayLabels,
        onClose: () => Navigator.pop(context),
        onConfirm: (start, _) => Navigator.pop(context, start),
      ),
    ),
  );
}

/// Shows a [YakCalendarPicker] in range mode and returns the selected range.
///
/// Returns `null` if the user closes without confirming.
Future<DateTimeRange?> showYakCalendarRangePicker({
  required BuildContext context,
  DateTime? initialStart,
  DateTime? initialEnd,
  DateTime? minDate,
  DateTime? maxDate,
  List<String>? periodTabs,
  int initialTabIndex = 1,
  ValueChanged<int>? onTabChanged,
  String continueLabel = 'Continue',
  String closeLabel = 'Close',
  String Function(int year, int month)? headerBuilder,
  List<String>? monthNames,
  List<String>? dayLabels,
}) {
  return showDialog<DateTimeRange>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: YakCalendarPicker(
        mode: YakCalendarMode.range,
        initialDate: initialStart,
        initialEndDate: initialEnd,
        minDate: minDate,
        maxDate: maxDate,
        periodTabs: periodTabs,
        initialTabIndex: initialTabIndex,
        onTabChanged: onTabChanged,
        continueLabel: continueLabel,
        closeLabel: closeLabel,
        headerBuilder: headerBuilder,
        monthNames: monthNames,
        dayLabels: dayLabels,
        onClose: () => Navigator.pop(context),
        onConfirm: (start, end) {
          if (end != null) {
            Navigator.pop(context, DateTimeRange(start: start, end: end));
          }
        },
      ),
    ),
  );
}

/// Calendar picker widget for the Yak design system.
///
/// Supports single-date and date-range selection with:
/// - Month navigation (prev/next arrows)
/// - Optional period tabs (e.g. Weekly / Monthly / Annual)
/// - Monday-first grid with overflow dates from adjacent months
/// - Range band rendering with yellow circles on start/end
/// - Today indicator (underline)
/// - Close and Continue action buttons
///
/// Use [showYakCalendarPicker] or [showYakCalendarRangePicker] for
/// convenient dialog presentation, or embed this widget directly.
class YakCalendarPicker extends StatefulWidget {
  /// Selection mode: single date or date range.
  final YakCalendarMode mode;

  /// Initial selected date (single mode) or range start (range mode).
  final DateTime? initialDate;

  /// Initial range end (range mode only).
  final DateTime? initialEndDate;

  /// Which month to display initially. Defaults to [initialDate]'s month or today.
  final DateTime? initialMonth;

  /// Minimum selectable date.
  final DateTime? minDate;

  /// Maximum selectable date.
  final DateTime? maxDate;

  /// Optional period filter tab labels (e.g. `['Weekly', 'Monthly', 'Annual']`).
  /// If null or empty, tabs are hidden.
  final List<String>? periodTabs;

  /// Initially selected tab index.
  final int initialTabIndex;

  /// Fired when a period tab is tapped.
  final ValueChanged<int>? onTabChanged;

  /// Fired when Close is tapped.
  final VoidCallback? onClose;

  /// Fired when Continue is tapped.
  /// In single mode: `end` is null.
  /// In range mode: both `start` and `end` are provided.
  final void Function(DateTime start, DateTime? end)? onConfirm;

  /// Label for the continue button.
  final String continueLabel;

  /// Label for the close button.
  final String closeLabel;

  /// Custom month header formatter. Receives (year, month 1-12).
  /// If null, uses `"MonthName Year"` format with [monthNames].
  final String Function(int year, int month)? headerBuilder;

  /// Month names (length 12). Defaults to English names.
  final List<String>? monthNames;

  /// Day-of-week header labels (length 7, starting Monday).
  /// Defaults to `['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sat', 'Su']`.
  final List<String>? dayLabels;

  const YakCalendarPicker({
    super.key,
    this.mode = YakCalendarMode.single,
    this.initialDate,
    this.initialEndDate,
    this.initialMonth,
    this.minDate,
    this.maxDate,
    this.periodTabs,
    this.initialTabIndex = 1,
    this.onTabChanged,
    this.onClose,
    this.onConfirm,
    this.continueLabel = 'Continue',
    this.closeLabel = 'Close',
    this.headerBuilder,
    this.monthNames,
    this.dayLabels,
  })  : assert(monthNames == null || monthNames.length == 12),
        assert(dayLabels == null || dayLabels.length == 7);

  @override
  State<YakCalendarPicker> createState() => _YakCalendarPickerState();
}

class _YakCalendarPickerState extends State<YakCalendarPicker> {
  late DateTime _displayedMonth;
  DateTime? _selectedDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late int _selectedTabIndex;

  static const List<String> _defaultMonthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const List<String> _defaultDayLabels = [
    'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sat', 'Su',
  ];

  List<String> get _monthNames => widget.monthNames ?? _defaultMonthNames;
  List<String> get _dayLabels => widget.dayLabels ?? _defaultDayLabels;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _rangeStart =
        widget.mode == YakCalendarMode.range ? widget.initialDate : null;
    _rangeEnd = widget.initialEndDate;
    _selectedTabIndex = widget.initialTabIndex;

    if (widget.initialMonth != null) {
      _displayedMonth =
          DateTime(widget.initialMonth!.year, widget.initialMonth!.month);
    } else if (widget.initialDate != null) {
      _displayedMonth =
          DateTime(widget.initialDate!.year, widget.initialDate!.month);
    } else {
      final now = DateTime.now();
      _displayedMonth = DateTime(now.year, now.month);
    }
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  // ---------------------------------------------------------------------------
  // Selection
  // ---------------------------------------------------------------------------

  void _onDayTapped(DateTime date) {
    setState(() {
      if (widget.mode == YakCalendarMode.single) {
        _selectedDate = date;
      } else {
        if (_rangeStart == null ||
            (_rangeStart != null && _rangeEnd != null)) {
          _rangeStart = date;
          _rangeEnd = null;
        } else {
          if (_isSameDay(date, _rangeStart!)) {
            _rangeStart = null;
          } else if (date.isBefore(_rangeStart!)) {
            _rangeEnd = _rangeStart;
            _rangeStart = date;
          } else {
            _rangeEnd = date;
          }
        }
      }
    });
  }

  void _handleContinue() {
    if (widget.mode == YakCalendarMode.single && _selectedDate != null) {
      widget.onConfirm?.call(_selectedDate!, null);
    } else if (widget.mode == YakCalendarMode.range && _rangeStart != null) {
      widget.onConfirm?.call(_rangeStart!, _rangeEnd);
    }
  }

  bool get _canContinue {
    if (widget.mode == YakCalendarMode.single) return _selectedDate != null;
    return _rangeStart != null && _rangeEnd != null;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isDateEnabled(DateTime date) {
    if (widget.minDate != null) {
      final min = widget.minDate!;
      if (date.isBefore(DateTime(min.year, min.month, min.day))) return false;
    }
    if (widget.maxDate != null) {
      final max = widget.maxDate!;
      if (date.isAfter(DateTime(max.year, max.month, max.day))) return false;
    }
    return true;
  }

  /// Generates 42 days (6 weeks) for the grid, starting from the Monday
  /// before (or on) the first of [_displayedMonth].
  List<DateTime> _generateGridDays() {
    final first = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final int leadingDays = (first.weekday - DateTime.monday) % 7;
    final gridStart = first.subtract(Duration(days: leadingDays));
    return List.generate(42, (i) => gridStart.add(Duration(days: i)));
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final days = _generateGridDays();
    final weeks = List.generate(6, (i) => days.sublist(i * 7, (i + 1) * 7));

    return Container(
      decoration: BoxDecoration(
        color: YakColor.semantic.background.baseMain,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCloseButton(),
          const SizedBox(height: 12),
          _buildMonthHeader(),
          if (widget.periodTabs != null &&
              widget.periodTabs!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildPeriodTabs(),
          ],
          const SizedBox(height: 16),
          _buildDayOfWeekHeaders(),
          const SizedBox(height: 4),
          ...List.generate(weeks.length, (i) {
            return Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 4),
              child: _buildWeekRow(weeks[i]),
            );
          }),
          const SizedBox(height: 20),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: widget.onClose,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            Icons.close,
            size: 20,
            color: YakColor.semantic.textAndIcons.baseMain,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    final headerText = widget.headerBuilder
            ?.call(_displayedMonth.year, _displayedMonth.month) ??
        '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _goToPreviousMonth,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.chevron_left,
              size: 24,
              color: YakColor.semantic.textAndIcons.baseMain,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          headerText,
          style: YakTypography.semantic.textM.semibold.copyWith(
            color: YakColor.semantic.textAndIcons.baseMain,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _goToNextMonth,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.chevron_right,
              size: 24,
              color: YakColor.semantic.textAndIcons.baseMain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.periodTabs!.length, (index) {
        final isSelected = index == _selectedTabIndex;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedTabIndex = index);
            widget.onTabChanged?.call(index);
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              widget.periodTabs![index],
              style: YakTypography.semantic.textS.medium.copyWith(
                color: isSelected
                    ? YakColor.primitive.primary.primary500
                    : YakColor.semantic.textAndIcons.baseSecond,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDayOfWeekHeaders() {
    return Row(
      children: _dayLabels
          .map((label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: YakTypography.semantic.textXS.regular.copyWith(
                      color: YakColor.semantic.textAndIcons.baseSecond,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildWeekRow(List<DateTime> week) {
    return SizedBox(
      height: 36,
      child: Row(
        children: week.map((date) {
          final isCurrentMonth =
              date.month == _displayedMonth.month &&
              date.year == _displayedMonth.year;
          return Expanded(child: _buildDayCell(date, isCurrentMonth));
        }).toList(),
      ),
    );
  }

  Widget _buildDayCell(DateTime date, bool isCurrentMonth) {
    final today = DateTime.now();
    final isToday = _isSameDay(date, today);
    final isEnabled = _isDateEnabled(date);

    bool isSelected = false;
    bool isRangeStart = false;
    bool isRangeEnd = false;
    bool isInRange = false;

    if (widget.mode == YakCalendarMode.single) {
      isSelected =
          _selectedDate != null && _isSameDay(date, _selectedDate!);
    } else {
      isRangeStart =
          _rangeStart != null && _isSameDay(date, _rangeStart!);
      isRangeEnd = _rangeEnd != null && _isSameDay(date, _rangeEnd!);
      if (_rangeStart != null &&
          _rangeEnd != null &&
          !_isSameDay(_rangeStart!, _rangeEnd!)) {
        isInRange = date.isAfter(_rangeStart!) &&
            date.isBefore(_rangeEnd!) &&
            !isRangeStart &&
            !isRangeEnd;
      }
    }

    final isEndpoint = isRangeStart || isRangeEnd;
    final isHighlighted = isSelected || isEndpoint;
    final hasRange = _rangeStart != null &&
        _rangeEnd != null &&
        !_isSameDay(_rangeStart!, _rangeEnd!);
    final showBand = hasRange && (isEndpoint || isInRange);

    final isMonday = date.weekday == DateTime.monday;
    final isSunday = date.weekday == DateTime.sunday;

    final Color textColor;
    if (!isEnabled) {
      textColor = YakColor.semantic.textAndIcons.disabled;
    } else if (!isCurrentMonth) {
      textColor = YakColor.semantic.textAndIcons.disabled;
    } else {
      textColor = YakColor.semantic.textAndIcons.baseMain;
    }

    final bandColor = YakColor.primitive.primary.primary100;
    const r = Radius.circular(4);

    return GestureDetector(
      onTap: isEnabled ? () => _onDayTapped(date) : null,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // In-between dates: full-width light yellow band (fills entire cell)
          if (showBand && isInRange)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: bandColor,
                  borderRadius: BorderRadius.horizontal(
                    left: isMonday ? r : Radius.zero,
                    right: isSunday ? r : Radius.zero,
                  ),
                ),
              ),
            ),
          // Range start: band extends to the right half
          if (showBand && isRangeStart && !isSunday)
            Positioned.fill(
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(child: Container(color: bandColor)),
                ],
              ),
            ),
          // Range end: band extends to the left half
          if (showBand && isRangeEnd && !isMonday)
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(child: Container(color: bandColor)),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          // Selected date: fills entire cell with rounded rectangle
          if (isHighlighted)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: YakColor.primitive.primary.primary500,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          // Date number + today underline
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${date.day}',
                style: YakTypography.semantic.textS.regular.copyWith(
                  color: isHighlighted
                      ? Colors.white
                      : textColor,
                ),
              ),
              if (isToday)
                Container(
                  width: 16,
                  height: 2,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? Colors.white
                        : YakColor.primitive.primary.primary500,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: YakColor.primitive.neutral.neutral700,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.closeLabel,
                style: YakTypography.semantic.textS.semibold.copyWith(
                  color: YakColor.semantic.textAndIcons.baseMain,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _canContinue ? _handleContinue : null,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _canContinue
                    ? YakColor.primitive.primary.primary500
                    : YakColor.primitive.neutral.neutral500,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.continueLabel,
                style: YakTypography.semantic.textS.semibold.copyWith(
                  color: _canContinue
                      ? YakColor.semantic.textAndIcons.baseMain
                      : YakColor.semantic.textAndIcons.disabled,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

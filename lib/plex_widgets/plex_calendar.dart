import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Scheduling month calendar (weekday headers + day cells).
///
/// Week, day, and agenda views are not part of this widget. This is not a
/// replacement for [PlexFormFieldDate].
class PlexCalendar extends StatefulWidget {
  const PlexCalendar({
    super.key,
    this.selected,
    this.onSelected,
    this.focusedMonth,
  });

  /// Highlighted day. Compared by calendar date (year/month/day).
  final DateTime? selected;

  /// Fired with `DateTime(year, month, day)` when a current-month cell is tapped.
  final ValueChanged<DateTime>? onSelected;

  /// Month to display. Falls back to [selected], then `DateTime.now()`.
  final DateTime? focusedMonth;

  @override
  State<PlexCalendar> createState() => _PlexCalendarState();
}

class _PlexCalendarState extends State<PlexCalendar> {
  late DateTime _visible;

  @override
  void initState() {
    super.initState();
    _visible = _monthFromProps();
  }

  @override
  void didUpdateWidget(PlexCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameMonth(widget.focusedMonth, oldWidget.focusedMonth) ||
        (widget.focusedMonth == null &&
            !_sameMonth(widget.selected, oldWidget.selected))) {
      _visible = _monthFromProps();
    }
  }

  DateTime _monthFromProps() {
    final DateTime src =
        widget.focusedMonth ?? widget.selected ?? DateTime.now();
    return DateTime(src.year, src.month);
  }

  static bool _sameMonth(DateTime? a, DateTime? b) {
    if (a == null || b == null) return a == b;
    return a.year == b.year && a.month == b.month;
  }

  static bool _sameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _shiftMonth(int delta) {
    setState(() {
      _visible = DateTime(_visible.year, _visible.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final DateTime today = DateTime.now();
    final DateTime first = DateTime(_visible.year, _visible.month, 1);
    final int daysInMonth = DateTime(_visible.year, _visible.month + 1, 0).day;
    // Monday-first grid (DateTime.weekday: 1 = Monday … 7 = Sunday).
    final int leading = first.weekday - 1;
    final int cellCount = leading + daysInMonth;
    final int trailing = (7 - (cellCount % 7)) % 7;
    final int totalCells = cellCount + trailing;
    final int weekCount = totalCells ~/ 7;

    final String heading = DateFormat.yMMMM().format(_visible);

    return Material(
      color: colors.surfaceCard,
      elevation: PlexElevation.xs,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PlexRadius.lg),
        side: BorderSide(color: colors.borderSubtle),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Toolbar(
            heading: heading,
            colors: colors,
            onPrevious: () => _shiftMonth(-1),
            onNext: () => _shiftMonth(1),
          ),
          _WeekdayHeader(colors: colors),
          for (int week = 0; week < weekCount; week++)
            _WeekRow(
              week: week,
              leading: leading,
              daysInMonth: daysInMonth,
              visible: _visible,
              selected: widget.selected,
              today: today,
              colors: colors,
              onSelected: widget.onSelected,
              sameDay: _sameDay,
            ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.heading,
    required this.colors,
    required this.onPrevious,
    required this.onNext,
  });

  final String heading;
  final PlexColorTokens colors;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PlexDim.small,
        PlexDim.small,
        PlexDim.small,
        PlexDim.smallest,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous month',
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.chevron_left, color: colors.textSecondary),
            onPressed: onPrevious,
          ),
          Expanded(
            child: Text(
              heading,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: PlexFontSize.bodyLarge,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Next month',
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.chevron_right, color: colors.textSecondary),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.colors});

  final PlexColorTokens colors;

  static final DateTime _monday = DateTime(2024, 1, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.surfaceSunken,
      padding: const EdgeInsets.symmetric(vertical: PlexDim.small),
      child: Row(
        children: [
          for (int i = 0; i < 7; i++)
            Expanded(
              child: Text(
                DateFormat.E().format(_monday.add(Duration(days: i))),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: PlexFontSize.smallest,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WeekRow extends StatelessWidget {
  const _WeekRow({
    required this.week,
    required this.leading,
    required this.daysInMonth,
    required this.visible,
    required this.selected,
    required this.today,
    required this.colors,
    required this.onSelected,
    required this.sameDay,
  });

  final int week;
  final int leading;
  final int daysInMonth;
  final DateTime visible;
  final DateTime? selected;
  final DateTime today;
  final PlexColorTokens colors;
  final ValueChanged<DateTime>? onSelected;
  final bool Function(DateTime?, DateTime?) sameDay;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int col = 0; col < 7; col++)
          Expanded(
            child: _DayCell(
              index: week * 7 + col,
              leading: leading,
              daysInMonth: daysInMonth,
              visible: visible,
              selected: selected,
              today: today,
              colors: colors,
              onSelected: onSelected,
              sameDay: sameDay,
            ),
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.index,
    required this.leading,
    required this.daysInMonth,
    required this.visible,
    required this.selected,
    required this.today,
    required this.colors,
    required this.onSelected,
    required this.sameDay,
  });

  final int index;
  final int leading;
  final int daysInMonth;
  final DateTime visible;
  final DateTime? selected;
  final DateTime today;
  final PlexColorTokens colors;
  final ValueChanged<DateTime>? onSelected;
  final bool Function(DateTime?, DateTime?) sameDay;

  @override
  Widget build(BuildContext context) {
    final int day = index - leading + 1;
    final bool inMonth = day >= 1 && day <= daysInMonth;
    if (!inMonth) {
      return const SizedBox(height: PlexDim.largePlus);
    }

    final DateTime date = DateTime(visible.year, visible.month, day);
    final bool isSelected = sameDay(selected, date);
    final bool isToday = sameDay(today, date);

    final Color fg = isSelected
        ? colors.textBrand
        : isToday
            ? colors.textBrand
            : colors.textPrimary;

    return SizedBox(
      height: PlexDim.largePlus,
      child: InkWell(
        onTap: () => onSelected?.call(date),
        customBorder: const CircleBorder(),
        child: Center(
          child: Container(
            width: PlexDim.largeMinus,
            height: PlexDim.largeMinus,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? colors.brandPrimary.withValues(alpha: 0.16)
                  : null,
              border: isSelected
                  ? Border.all(color: colors.brandPrimary)
                  : isToday
                      ? Border.all(color: colors.brandPrimary)
                      : null,
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: fg,
                fontSize: PlexFontSize.caption,
                fontWeight: isSelected || isToday
                    ? FontWeight.w700
                    : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Layout for [PlexCalendar].
enum PlexCalendarView {
  month,
  week,
  day,
  agenda,
}

/// Timed item shown on [PlexCalendar].
class PlexCalendarEvent {
  const PlexCalendarEvent({
    required this.id,
    required this.start,
    required this.title,
    this.end,
    this.color,
  });

  final String id;
  final DateTime start;
  final String title;
  final DateTime? end;
  final Color? color;
}

/// Scheduling calendar (month, week, day, agenda).
///
/// This is not a replacement for [PlexFormFieldDate].
class PlexCalendar extends StatefulWidget {
  const PlexCalendar({
    super.key,
    this.selected,
    this.onSelected,
    this.focusedMonth,
    this.view = PlexCalendarView.month,
    this.events = const <PlexCalendarEvent>[],
    this.onEventTap,
  });

  /// Highlighted day. Compared by calendar date (year/month/day).
  final DateTime? selected;

  /// Fired with `DateTime(year, month, day)` when a current-month cell is tapped.
  final ValueChanged<DateTime>? onSelected;

  /// Month to display. Falls back to [selected], then `DateTime.now()`.
  final DateTime? focusedMonth;

  /// Visible layout. Defaults to [PlexCalendarView.month].
  final PlexCalendarView view;

  /// Items plotted on the calendar. Day membership uses [start] (year/month/day).
  final List<PlexCalendarEvent> events;

  /// Fired when an event row is tapped (week, day, and agenda lists).
  final ValueChanged<PlexCalendarEvent>? onEventTap;

  @override
  State<PlexCalendar> createState() => _PlexCalendarState();
}

class _PlexCalendarState extends State<PlexCalendar> {
  late DateTime _visible;

  static const double _dayCellHeight = PlexDim.extraLargeMinus;

  @override
  void initState() {
    super.initState();
    _visible = _visibleFromProps();
  }

  @override
  void didUpdateWidget(PlexCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.view != oldWidget.view) {
      _visible = _visibleFromProps();
      return;
    }
    switch (widget.view) {
      case PlexCalendarView.month:
      case PlexCalendarView.agenda:
        if (!_sameMonth(widget.focusedMonth, oldWidget.focusedMonth) ||
            (widget.focusedMonth == null &&
                !_sameMonth(widget.selected, oldWidget.selected))) {
          _visible = _monthFromProps();
        }
      case PlexCalendarView.week:
      case PlexCalendarView.day:
        final DateTime? next = widget.selected ?? widget.focusedMonth;
        final DateTime? prev = oldWidget.selected ?? oldWidget.focusedMonth;
        if (!_sameCalendarDay(next, prev)) {
          _visible = _anchorFromProps();
        }
    }
  }

  DateTime _visibleFromProps() {
    switch (widget.view) {
      case PlexCalendarView.month:
      case PlexCalendarView.agenda:
        return _monthFromProps();
      case PlexCalendarView.week:
      case PlexCalendarView.day:
        return _anchorFromProps();
    }
  }

  DateTime _monthFromProps() {
    final DateTime src =
        widget.focusedMonth ?? widget.selected ?? DateTime.now();
    return DateTime(src.year, src.month);
  }

  /// Week/day focus: selected day, else focused month, else now.
  DateTime _anchorFromProps() {
    final DateTime src =
        widget.selected ?? widget.focusedMonth ?? DateTime.now();
    return DateTime(src.year, src.month, src.day);
  }

  static bool _sameMonth(DateTime? a, DateTime? b) {
    if (a == null || b == null) return a == b;
    return a.year == b.year && a.month == b.month;
  }

  static bool _sameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool _sameCalendarDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return a == b;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime _weekStart(DateTime date) {
    final DateTime day = DateTime(date.year, date.month, date.day);
    return DateTime(day.year, day.month, day.day - (day.weekday - 1));
  }

  static String _timeLabel(PlexCalendarEvent event) {
    final String start = DateFormat.jm().format(event.start);
    final DateTime? end = event.end;
    if (end == null) return start;
    return '$start – ${DateFormat.jm().format(end)}';
  }

  List<PlexCalendarEvent> _eventsOn(DateTime day) {
    final List<PlexCalendarEvent> out = <PlexCalendarEvent>[];
    for (final PlexCalendarEvent event in widget.events) {
      if (_sameDay(event.start, day)) out.add(event);
    }
    out.sort(
      (PlexCalendarEvent a, PlexCalendarEvent b) => a.start.compareTo(b.start),
    );
    return out;
  }

  List<PlexCalendarEvent> _eventsInWeek(DateTime weekStart) {
    final List<PlexCalendarEvent> out = <PlexCalendarEvent>[];
    for (int i = 0; i < 7; i++) {
      out.addAll(
        _eventsOn(DateTime(weekStart.year, weekStart.month, weekStart.day + i)),
      );
    }
    return out;
  }

  List<PlexCalendarEvent> _agendaEvents() {
    final List<PlexCalendarEvent> inMonth = <PlexCalendarEvent>[];
    for (final PlexCalendarEvent event in widget.events) {
      if (event.start.year == _visible.year &&
          event.start.month == _visible.month) {
        inMonth.add(event);
      }
    }
    final List<PlexCalendarEvent> source = inMonth.isNotEmpty
        ? inMonth
        : List<PlexCalendarEvent>.from(widget.events);
    source.sort(
      (PlexCalendarEvent a, PlexCalendarEvent b) => a.start.compareTo(b.start),
    );
    return source;
  }

  void _shift(int delta) {
    setState(() {
      switch (widget.view) {
        case PlexCalendarView.month:
        case PlexCalendarView.agenda:
          _visible = DateTime(_visible.year, _visible.month + delta);
        case PlexCalendarView.week:
          _visible = DateTime(
            _visible.year,
            _visible.month,
            _visible.day + 7 * delta,
          );
        case PlexCalendarView.day:
          _visible = DateTime(
            _visible.year,
            _visible.month,
            _visible.day + delta,
          );
      }
    });
  }

  String _heading() {
    switch (widget.view) {
      case PlexCalendarView.month:
      case PlexCalendarView.agenda:
        return DateFormat.yMMMM().format(_visible);
      case PlexCalendarView.week:
        final DateTime start = _weekStart(_visible);
        final DateTime end = DateTime(start.year, start.month, start.day + 6);
        if (start.year == end.year && start.month == end.month) {
          return '${DateFormat.MMMd().format(start)} – ${DateFormat.d().format(end)}, ${start.year}';
        }
        if (start.year == end.year) {
          return '${DateFormat.MMMd().format(start)} – ${DateFormat.MMMd().format(end)}, ${start.year}';
        }
        return '${DateFormat.yMMMd().format(start)} – ${DateFormat.yMMMd().format(end)}';
      case PlexCalendarView.day:
        return DateFormat.yMMMEd().format(_visible);
    }
  }

  String get _previousTooltip {
    switch (widget.view) {
      case PlexCalendarView.month:
      case PlexCalendarView.agenda:
        return 'Previous month';
      case PlexCalendarView.week:
        return 'Previous week';
      case PlexCalendarView.day:
        return 'Previous day';
    }
  }

  String get _nextTooltip {
    switch (widget.view) {
      case PlexCalendarView.month:
      case PlexCalendarView.agenda:
        return 'Next month';
      case PlexCalendarView.week:
        return 'Next week';
      case PlexCalendarView.day:
        return 'Next day';
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final DateTime today = DateTime.now();

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
            heading: _heading(),
            colors: colors,
            previousTooltip: _previousTooltip,
            nextTooltip: _nextTooltip,
            onPrevious: () => _shift(-1),
            onNext: () => _shift(1),
          ),
          ..._body(colors: colors, today: today),
        ],
      ),
    );
  }

  List<Widget> _body({
    required PlexColorTokens colors,
    required DateTime today,
  }) {
    switch (widget.view) {
      case PlexCalendarView.month:
        return _monthBody(colors: colors, today: today);
      case PlexCalendarView.week:
        return _weekBody(colors: colors, today: today);
      case PlexCalendarView.day:
        return _dayBody(colors: colors);
      case PlexCalendarView.agenda:
        return _agendaBody(colors: colors);
    }
  }

  List<Widget> _monthBody({
    required PlexColorTokens colors,
    required DateTime today,
  }) {
    final DateTime first = DateTime(_visible.year, _visible.month, 1);
    final int daysInMonth = DateTime(_visible.year, _visible.month + 1, 0).day;
    // Monday-first grid (DateTime.weekday: 1 = Monday … 7 = Sunday).
    final int leading = first.weekday - 1;
    final int cellCount = leading + daysInMonth;
    final int trailing = (7 - (cellCount % 7)) % 7;
    final int totalCells = cellCount + trailing;
    final int weekCount = totalCells ~/ 7;

    return <Widget>[
      _WeekdayHeader(colors: colors),
      for (int week = 0; week < weekCount; week++)
        _WeekRow(
          week: week,
          leading: leading,
          daysInMonth: daysInMonth,
          visible: _visible,
          selected: widget.selected,
          today: today,
          events: widget.events,
          colors: colors,
          onSelected: widget.onSelected,
          sameDay: _sameDay,
          cellHeight: _dayCellHeight,
        ),
    ];
  }

  List<Widget> _weekBody({
    required PlexColorTokens colors,
    required DateTime today,
  }) {
    final DateTime start = _weekStart(_visible);
    final List<PlexCalendarEvent> weekEvents = _eventsInWeek(start);
    return <Widget>[
      _WeekdayHeader(colors: colors),
      Row(
        children: [
          for (int i = 0; i < 7; i++)
            Expanded(
              child: _FocusDayCell(
                date: DateTime(start.year, start.month, start.day + i),
                selected: widget.selected,
                today: today,
                events: widget.events,
                colors: colors,
                onSelected: widget.onSelected,
                sameDay: _sameDay,
                cellHeight: _dayCellHeight,
              ),
            ),
        ],
      ),
      _EventList(
        events: weekEvents,
        colors: colors,
        emptyLabel: 'No events this week',
        showDate: true,
        showTime: true,
        onEventTap: widget.onEventTap,
        timeLabel: _timeLabel,
      ),
    ];
  }

  List<Widget> _dayBody({required PlexColorTokens colors}) {
    final List<PlexCalendarEvent> dayEvents = _eventsOn(_visible);
    return <Widget>[
      _EventList(
        events: dayEvents,
        colors: colors,
        emptyLabel: 'No events',
        showDate: false,
        showTime: true,
        onEventTap: widget.onEventTap,
        timeLabel: _timeLabel,
        hourGutter: true,
      ),
    ];
  }

  List<Widget> _agendaBody({required PlexColorTokens colors}) {
    return <Widget>[
      _EventList(
        events: _agendaEvents(),
        colors: colors,
        emptyLabel: 'No events',
        showDate: true,
        showTime: false,
        onEventTap: widget.onEventTap,
        timeLabel: _timeLabel,
      ),
    ];
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.heading,
    required this.colors,
    required this.onPrevious,
    required this.onNext,
    this.previousTooltip = 'Previous month',
    this.nextTooltip = 'Next month',
  });

  final String heading;
  final PlexColorTokens colors;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String previousTooltip;
  final String nextTooltip;

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
            tooltip: previousTooltip,
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
            tooltip: nextTooltip,
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
    required this.events,
    required this.colors,
    required this.onSelected,
    required this.sameDay,
    required this.cellHeight,
  });

  final int week;
  final int leading;
  final int daysInMonth;
  final DateTime visible;
  final DateTime? selected;
  final DateTime today;
  final List<PlexCalendarEvent> events;
  final PlexColorTokens colors;
  final ValueChanged<DateTime>? onSelected;
  final bool Function(DateTime?, DateTime?) sameDay;
  final double cellHeight;

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
              events: events,
              colors: colors,
              onSelected: onSelected,
              sameDay: sameDay,
              cellHeight: cellHeight,
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
    required this.events,
    required this.colors,
    required this.onSelected,
    required this.sameDay,
    required this.cellHeight,
  });

  final int index;
  final int leading;
  final int daysInMonth;
  final DateTime visible;
  final DateTime? selected;
  final DateTime today;
  final List<PlexCalendarEvent> events;
  final PlexColorTokens colors;
  final ValueChanged<DateTime>? onSelected;
  final bool Function(DateTime?, DateTime?) sameDay;
  final double cellHeight;

  @override
  Widget build(BuildContext context) {
    final int day = index - leading + 1;
    final bool inMonth = day >= 1 && day <= daysInMonth;
    if (!inMonth) {
      return SizedBox(height: cellHeight);
    }

    return _FocusDayCell(
      date: DateTime(visible.year, visible.month, day),
      selected: selected,
      today: today,
      events: events,
      colors: colors,
      onSelected: onSelected,
      sameDay: sameDay,
      cellHeight: cellHeight,
    );
  }
}

class _FocusDayCell extends StatelessWidget {
  const _FocusDayCell({
    required this.date,
    required this.selected,
    required this.today,
    required this.events,
    required this.colors,
    required this.onSelected,
    required this.sameDay,
    required this.cellHeight,
  });

  final DateTime date;
  final DateTime? selected;
  final DateTime today;
  final List<PlexCalendarEvent> events;
  final PlexColorTokens colors;
  final ValueChanged<DateTime>? onSelected;
  final bool Function(DateTime?, DateTime?) sameDay;
  final double cellHeight;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = sameDay(selected, date);
    final bool isToday = sameDay(today, date);

    final List<Color> dots = <Color>[];
    for (final PlexCalendarEvent event in events) {
      if (!sameDay(event.start, date)) continue;
      dots.add(event.color ?? colors.brandPrimary);
      if (dots.length >= 3) break;
    }

    final Color fg = isSelected
        ? colors.textBrand
        : isToday
            ? colors.textBrand
            : colors.textPrimary;

    return SizedBox(
      height: cellHeight,
      child: InkWell(
        onTap: () => onSelected?.call(date),
        customBorder: const CircleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                '${date.day}',
                style: TextStyle(
                  color: fg,
                  fontSize: PlexFontSize.caption,
                  fontWeight:
                      isSelected || isToday ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              height: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < dots.length; i++) ...[
                    if (i > 0) const SizedBox(width: 2),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: dots[i],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventList extends StatelessWidget {
  const _EventList({
    required this.events,
    required this.colors,
    required this.emptyLabel,
    required this.showDate,
    required this.showTime,
    required this.timeLabel,
    this.onEventTap,
    this.hourGutter = false,
  });

  final List<PlexCalendarEvent> events;
  final PlexColorTokens colors;
  final String emptyLabel;
  final bool showDate;
  final bool showTime;
  final bool hourGutter;
  final ValueChanged<PlexCalendarEvent>? onEventTap;
  final String Function(PlexCalendarEvent) timeLabel;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          PlexDim.medium,
          PlexDim.small,
          PlexDim.medium,
          PlexDim.medium,
        ),
        child: Text(
          emptyLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.textMuted,
            fontSize: PlexFontSize.caption,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: PlexDim.small),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final PlexCalendarEvent event in events)
            _EventTile(
              event: event,
              colors: colors,
              showDate: showDate,
              showTime: showTime,
              hourGutter: hourGutter,
              timeLabel: timeLabel,
              onTap: onEventTap == null ? null : () => onEventTap!(event),
            ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.event,
    required this.colors,
    required this.showDate,
    required this.showTime,
    required this.hourGutter,
    required this.timeLabel,
    this.onTap,
  });

  final PlexCalendarEvent event;
  final PlexColorTokens colors;
  final bool showDate;
  final bool showTime;
  final bool hourGutter;
  final String Function(PlexCalendarEvent) timeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color accent = event.color ?? colors.brandPrimary;
    final String? meta = showDate
        ? DateFormat.MMMd().format(event.start)
        : (showTime ? timeLabel(event) : null);
    final String? time = showTime && showDate ? timeLabel(event) : null;

    final Widget body = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hourGutter && showTime)
          SizedBox(
            width: 72,
            child: Text(
              DateFormat.jm().format(event.start),
              style: TextStyle(
                color: colors.textMuted,
                fontSize: PlexFontSize.caption,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
          width: 4,
          height: PlexDim.largeMinus,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(PlexRadius.xs),
          ),
        ),
        const SizedBox(width: PlexDim.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (meta != null && !hourGutter)
                Text(
                  time == null ? meta : '$meta · $time',
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: PlexFontSize.smallest,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Text(
                event.title,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: PlexFontSize.body,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (hourGutter && event.end != null)
                Text(
                  timeLabel(event),
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: PlexFontSize.caption,
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          PlexDim.medium,
          PlexDim.small,
          PlexDim.medium,
          PlexDim.small,
        ),
        child: body,
      ),
    );
  }
}

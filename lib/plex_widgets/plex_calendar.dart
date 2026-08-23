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

/// How often a [PlexCalendarRecurrence] repeats.
enum PlexCalendarFrequency {
  daily,
  weekly,
}

/// RRULE-lite rule for expanding a [PlexCalendarEvent] across a date range.
class PlexCalendarRecurrence {
  const PlexCalendarRecurrence({
    this.frequency = PlexCalendarFrequency.daily,
    this.interval = 1,
    this.count,
    this.until,
  });

  factory PlexCalendarRecurrence.daily({
    int interval = 1,
    int? count,
    DateTime? until,
  }) {
    return PlexCalendarRecurrence(
      frequency: PlexCalendarFrequency.daily,
      interval: interval,
      count: count,
      until: until,
    );
  }

  factory PlexCalendarRecurrence.weekly({
    int interval = 1,
    int? count,
    DateTime? until,
  }) {
    return PlexCalendarRecurrence(
      frequency: PlexCalendarFrequency.weekly,
      interval: interval,
      count: count,
      until: until,
    );
  }

  /// Daily or weekly.
  final PlexCalendarFrequency frequency;

  /// Step between instances. Values below 1 are treated as 1.
  final int interval;

  /// Maximum number of instances, including the original start.
  final int? count;

  /// Inclusive calendar date; instances after this date are omitted.
  final DateTime? until;

  static const int _maxIterations = 10000;

  /// Expands [event] into occurrences whose start date falls on or between
  /// [rangeStart] and [rangeEnd] (inclusive dates).
  ///
  /// Stops at [count] instances, [until] (inclusive date), or [rangeEnd],
  /// whichever comes first. Daily steps [interval] days; weekly steps
  /// [interval] weeks on the same weekday as [PlexCalendarEvent.start].
  ///
  /// Occurrence ids are `'${event.id}#${yyyyMMdd}'`. The master id is stored
  /// on [PlexCalendarEvent.occurrenceOf]. Start/end are shifted by the same
  /// duration. Events without a rule are returned unchanged when in range.
  static List<PlexCalendarEvent> expand(
    PlexCalendarEvent event, {
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    final DateTime from = _dateOnly(rangeStart);
    final DateTime to = _dateOnly(rangeEnd);
    if (to.isBefore(from)) return const <PlexCalendarEvent>[];

    final PlexCalendarRecurrence? rule = event.recurrence;
    if (rule == null || event.occurrenceOf != null) {
      return _inInclusiveDateRange(event.start, from, to)
          ? <PlexCalendarEvent>[event]
          : const <PlexCalendarEvent>[];
    }

    final int step = rule.interval < 1 ? 1 : rule.interval;
    final int? count = rule.count;
    if (count != null && count <= 0) return const <PlexCalendarEvent>[];

    final DateTime? untilDate =
        rule.until == null ? null : _dateOnly(rule.until!);
    final Duration span = event.end == null
        ? Duration.zero
        : event.end!.difference(event.start);

    final List<PlexCalendarEvent> out = <PlexCalendarEvent>[];
    DateTime cursor = event.start;
    int generated = 0;
    int guard = 0;

    while (guard++ < _maxIterations) {
      final DateTime cursorDay = _dateOnly(cursor);
      if (untilDate != null && cursorDay.isAfter(untilDate)) break;
      if (cursorDay.isAfter(to)) break;

      generated++;
      if (count != null && generated > count) break;

      if (!cursorDay.isBefore(from)) {
        out.add(
          PlexCalendarEvent(
            id: '${event.id}#${_yyyyMMdd(cursor)}',
            start: cursor,
            end: event.end == null ? null : cursor.add(span),
            title: event.title,
            color: event.color,
            occurrenceOf: event.occurrenceOf ?? event.id,
          ),
        );
      }

      if (count != null && generated >= count) break;
      cursor = _advance(cursor, rule.frequency, step);
    }

    return out;
  }

  static DateTime _advance(
    DateTime cursor,
    PlexCalendarFrequency frequency,
    int step,
  ) {
    switch (frequency) {
      case PlexCalendarFrequency.daily:
        return DateTime(
          cursor.year,
          cursor.month,
          cursor.day + step,
          cursor.hour,
          cursor.minute,
          cursor.second,
          cursor.millisecond,
          cursor.microsecond,
        );
      case PlexCalendarFrequency.weekly:
        return DateTime(
          cursor.year,
          cursor.month,
          cursor.day + (7 * step),
          cursor.hour,
          cursor.minute,
          cursor.second,
          cursor.millisecond,
          cursor.microsecond,
        );
    }
  }
}

/// Timed item shown on [PlexCalendar].
class PlexCalendarEvent {
  const PlexCalendarEvent({
    required this.id,
    required this.start,
    required this.title,
    this.end,
    this.color,
    this.recurrence,
    this.occurrenceOf,
  });

  final String id;
  final DateTime start;
  final String title;
  final DateTime? end;
  final Color? color;

  /// Optional repeat rule. Expanded by [PlexCalendar] when
  /// [PlexCalendar.expandRecurrence] is true.
  final PlexCalendarRecurrence? recurrence;

  /// Master event id when this row is an expanded occurrence.
  final String? occurrenceOf;

  PlexCalendarEvent copyWith({
    String? id,
    DateTime? start,
    String? title,
    DateTime? end,
    Color? color,
    PlexCalendarRecurrence? recurrence,
    String? occurrenceOf,
  }) {
    return PlexCalendarEvent(
      id: id ?? this.id,
      start: start ?? this.start,
      title: title ?? this.title,
      end: end ?? this.end,
      color: color ?? this.color,
      recurrence: recurrence ?? this.recurrence,
      occurrenceOf: occurrenceOf ?? this.occurrenceOf,
    );
  }
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
    this.onEventMoved,
    this.onEventResized,
    this.expandRecurrence = true,
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

  /// Fired when an event is dropped on another day or hour slot.
  /// [PlexCalendarEvent.start] is the drop time; [PlexCalendarEvent.end] is
  /// shifted by the same duration. Null keeps tap-only behavior.
  final ValueChanged<PlexCalendarEvent>? onEventMoved;

  /// Fired when the bottom resize handle changes [PlexCalendarEvent.end]
  /// in 15-minute steps. Start is unchanged. Null hides the handle.
  final ValueChanged<PlexCalendarEvent>? onEventResized;

  /// When true (default), recurring events are expanded for the visible range.
  final bool expandRecurrence;

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

  List<PlexCalendarEvent> _expandedEvents() {
    if (!widget.expandRecurrence) {
      return widget.events;
    }
    final DateTime rangeStart;
    final DateTime rangeEnd;
    switch (widget.view) {
      case PlexCalendarView.month:
      case PlexCalendarView.agenda:
        rangeStart = DateTime(_visible.year, _visible.month, 1);
        rangeEnd = DateTime(_visible.year, _visible.month + 1, 0);
      case PlexCalendarView.week:
        rangeStart = _weekStart(_visible);
        rangeEnd = DateTime(rangeStart.year, rangeStart.month, rangeStart.day + 6);
      case PlexCalendarView.day:
        rangeStart = DateTime(_visible.year, _visible.month, _visible.day);
        rangeEnd = rangeStart;
    }
    final List<PlexCalendarEvent> out = <PlexCalendarEvent>[];
    for (final PlexCalendarEvent event in widget.events) {
      out.addAll(
        PlexCalendarRecurrence.expand(
          event,
          rangeStart: rangeStart,
          rangeEnd: rangeEnd,
        ),
      );
    }
    return out;
  }

  List<PlexCalendarEvent> _eventsOn(
    DateTime day,
    List<PlexCalendarEvent> events,
  ) {
    final List<PlexCalendarEvent> out = <PlexCalendarEvent>[];
    for (final PlexCalendarEvent event in events) {
      if (_sameDay(event.start, day)) out.add(event);
    }
    out.sort(
      (PlexCalendarEvent a, PlexCalendarEvent b) => a.start.compareTo(b.start),
    );
    return out;
  }

  List<PlexCalendarEvent> _eventsInWeek(
    DateTime weekStart,
    List<PlexCalendarEvent> events,
  ) {
    final List<PlexCalendarEvent> out = <PlexCalendarEvent>[];
    for (int i = 0; i < 7; i++) {
      out.addAll(
        _eventsOn(
          DateTime(weekStart.year, weekStart.month, weekStart.day + i),
          events,
        ),
      );
    }
    return out;
  }

  List<PlexCalendarEvent> _agendaEvents(List<PlexCalendarEvent> events) {
    final List<PlexCalendarEvent> inMonth = <PlexCalendarEvent>[];
    for (final PlexCalendarEvent event in events) {
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

  void _moveToDate(PlexCalendarEvent event, DateTime date) {
    final DateTime newStart = DateTime(
      date.year,
      date.month,
      date.day,
      event.start.hour,
      event.start.minute,
      event.start.second,
      event.start.millisecond,
      event.start.microsecond,
    );
    if (newStart.isAtSameMomentAs(event.start)) return;
    widget.onEventMoved?.call(_shiftEvent(event, newStart));
  }

  void _moveToHour(PlexCalendarEvent event, DateTime date, int hour) {
    final DateTime newStart = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
    );
    if (newStart.isAtSameMomentAs(event.start)) return;
    widget.onEventMoved?.call(_shiftEvent(event, newStart));
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final DateTime today = DateTime.now();
    final List<PlexCalendarEvent> displayEvents = _expandedEvents();

    final Widget toolbar = _Toolbar(
      heading: _heading(),
      colors: colors,
      previousTooltip: _previousTooltip,
      nextTooltip: _nextTooltip,
      onPrevious: () => _shift(-1),
      onNext: () => _shift(1),
    );
    final List<Widget> body = _body(
      colors: colors,
      today: today,
      displayEvents: displayEvents,
    );

    return Material(
      color: colors.surfaceCard,
      elevation: PlexElevation.xs,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PlexRadius.lg),
        side: BorderSide(color: colors.borderSubtle),
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (!constraints.maxHeight.isFinite) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [toolbar, ...body],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              toolbar,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: body,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _body({
    required PlexColorTokens colors,
    required DateTime today,
    required List<PlexCalendarEvent> displayEvents,
  }) {
    switch (widget.view) {
      case PlexCalendarView.month:
        return _monthBody(
          colors: colors,
          today: today,
          displayEvents: displayEvents,
        );
      case PlexCalendarView.week:
        return _weekBody(
          colors: colors,
          today: today,
          displayEvents: displayEvents,
        );
      case PlexCalendarView.day:
        return _dayBody(colors: colors, displayEvents: displayEvents);
      case PlexCalendarView.agenda:
        return _agendaBody(colors: colors, displayEvents: displayEvents);
    }
  }

  List<Widget> _monthBody({
    required PlexColorTokens colors,
    required DateTime today,
    required List<PlexCalendarEvent> displayEvents,
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
          events: displayEvents,
          colors: colors,
          onSelected: widget.onSelected,
          onEventTap: widget.onEventTap,
          onEventMoved: widget.onEventMoved,
          showEventChips: true,
          sameDay: _sameDay,
          cellHeight: _dayCellHeight,
        ),
    ];
  }

  List<Widget> _weekBody({
    required PlexColorTokens colors,
    required DateTime today,
    required List<PlexCalendarEvent> displayEvents,
  }) {
    final DateTime start = _weekStart(_visible);
    final List<PlexCalendarEvent> weekEvents =
        _eventsInWeek(start, displayEvents);
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
                events: displayEvents,
                colors: colors,
                onSelected: widget.onSelected,
                onEventTap: widget.onEventTap,
                onEventMoved: widget.onEventMoved,
                showEventChips: false,
                sameDay: _sameDay,
                cellHeight: _dayCellHeight,
              ),
            ),
        ],
      ),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < 7; i++)
              Expanded(
                child: _DayEventColumn(
                  date: DateTime(start.year, start.month, start.day + i),
                  events: _eventsOn(
                    DateTime(start.year, start.month, start.day + i),
                    weekEvents,
                  ),
                  colors: colors,
                  onEventTap: widget.onEventTap,
                  onEventMoved: widget.onEventMoved,
                  onEventResized: widget.onEventResized,
                  onDropEvent: widget.onEventMoved == null
                      ? null
                      : (PlexCalendarEvent event) => _moveToDate(
                            event,
                            DateTime(start.year, start.month, start.day + i),
                          ),
                  timeLabel: _timeLabel,
                ),
              ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _dayBody({
    required PlexColorTokens colors,
    required List<PlexCalendarEvent> displayEvents,
  }) {
    final List<PlexCalendarEvent> dayEvents =
        _eventsOn(_visible, displayEvents);
    return <Widget>[
      for (int hour = 0; hour < 24; hour++)
        _HourSlot(
          hour: hour,
          events: [
            for (final PlexCalendarEvent event in dayEvents)
              if (event.start.hour == hour) event,
          ],
          colors: colors,
          onEventTap: widget.onEventTap,
          onEventMoved: widget.onEventMoved,
          onEventResized: widget.onEventResized,
          onDropEvent: widget.onEventMoved == null
              ? null
              : (PlexCalendarEvent event) =>
                  _moveToHour(event, _visible, hour),
          timeLabel: _timeLabel,
        ),
    ];
  }

  List<Widget> _agendaBody({
    required PlexColorTokens colors,
    required List<PlexCalendarEvent> displayEvents,
  }) {
    return <Widget>[
      _EventList(
        events: _agendaEvents(displayEvents),
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
    this.onEventTap,
    this.onEventMoved,
    this.showEventChips = false,
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
  final ValueChanged<PlexCalendarEvent>? onEventTap;
  final ValueChanged<PlexCalendarEvent>? onEventMoved;
  final bool showEventChips;
  final bool Function(DateTime?, DateTime?) sameDay;
  final double cellHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              onEventTap: onEventTap,
              onEventMoved: onEventMoved,
              showEventChips: showEventChips,
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
    this.onEventTap,
    this.onEventMoved,
    this.showEventChips = false,
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
  final ValueChanged<PlexCalendarEvent>? onEventTap;
  final ValueChanged<PlexCalendarEvent>? onEventMoved;
  final bool showEventChips;
  final bool Function(DateTime?, DateTime?) sameDay;
  final double cellHeight;

  @override
  Widget build(BuildContext context) {
    final int day = index - leading + 1;
    final bool inMonth = day >= 1 && day <= daysInMonth;
    if (!inMonth) {
      return SizedBox(
        height: cellHeight + (showEventChips ? PlexDim.large + PlexDim.smallest : 0),
      );
    }

    return _FocusDayCell(
      date: DateTime(visible.year, visible.month, day),
      selected: selected,
      today: today,
      events: events,
      colors: colors,
      onSelected: onSelected,
      onEventTap: onEventTap,
      onEventMoved: onEventMoved,
      showEventChips: showEventChips,
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
    this.onEventTap,
    this.onEventMoved,
    this.showEventChips = false,
  });

  final DateTime date;
  final DateTime? selected;
  final DateTime today;
  final List<PlexCalendarEvent> events;
  final PlexColorTokens colors;
  final ValueChanged<DateTime>? onSelected;
  final ValueChanged<PlexCalendarEvent>? onEventTap;
  final ValueChanged<PlexCalendarEvent>? onEventMoved;
  final bool showEventChips;
  final bool Function(DateTime?, DateTime?) sameDay;
  final double cellHeight;

  static const int _chipMax = 2;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = sameDay(selected, date);
    final bool isToday = sameDay(today, date);

    final List<PlexCalendarEvent> dayEvents = <PlexCalendarEvent>[];
    final List<Color> dots = <Color>[];
    for (final PlexCalendarEvent event in events) {
      if (!sameDay(event.start, date)) continue;
      dayEvents.add(event);
      if (dots.length < 3) {
        dots.add(event.color ?? colors.brandPrimary);
      }
    }

    final Color fg = isSelected
        ? colors.textBrand
        : isToday
            ? colors.textBrand
            : colors.textPrimary;

    final double chipBand =
        showEventChips ? PlexDim.large + PlexDim.smallest : 0;

    Widget cell = SizedBox(
      height: cellHeight + chipBand,
      child: Column(
        children: [
          Expanded(
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
                        fontWeight: isSelected || isToday
                            ? FontWeight.w700
                            : FontWeight.w600,
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
          ),
          if (showEventChips)
            SizedBox(
              height: chipBand,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    for (final PlexCalendarEvent event
                        in dayEvents.take(_chipMax))
                      _MonthEventChip(
                        event: event,
                        colors: colors,
                        onEventTap: onEventTap,
                        onEventMoved: onEventMoved,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    if (showEventChips) {
      cell = KeyedSubtree(
        key: Key('plex-cal-day-${_yyyyMMdd(date)}'),
        child: cell,
      );
    }

    if (onEventMoved == null) return cell;

    return DragTarget<PlexCalendarEvent>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (DragTargetDetails<PlexCalendarEvent> details) {
        final PlexCalendarEvent event = details.data;
        final DateTime newStart = DateTime(
          date.year,
          date.month,
          date.day,
          event.start.hour,
          event.start.minute,
          event.start.second,
          event.start.millisecond,
          event.start.microsecond,
        );
        if (newStart.isAtSameMomentAs(event.start)) return;
        onEventMoved!(_shiftEvent(event, newStart));
      },
      builder: (
        BuildContext context,
        List<PlexCalendarEvent?> candidate,
        List<dynamic> rejected,
      ) {
        final bool hovering = candidate.isNotEmpty;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: hovering
                ? colors.brandPrimary.withValues(alpha: 0.10)
                : null,
          ),
          child: cell,
        );
      },
    );
  }
}

class _MonthEventChip extends StatelessWidget {
  const _MonthEventChip({
    required this.event,
    required this.colors,
    this.onEventTap,
    this.onEventMoved,
  });

  final PlexCalendarEvent event;
  final PlexColorTokens colors;
  final ValueChanged<PlexCalendarEvent>? onEventTap;
  final ValueChanged<PlexCalendarEvent>? onEventMoved;

  @override
  Widget build(BuildContext context) {
    final Color accent = event.color ?? colors.brandPrimary;
    final Widget chip = GestureDetector(
      onTap: onEventTap == null ? null : () => onEventTap!(event),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(PlexRadius.xs),
        ),
        child: Text(
          event.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: PlexFontSize.smallest,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    final Widget body = onEventMoved == null
        ? chip
        : LongPressDraggable<PlexCalendarEvent>(
            data: event,
            hapticFeedbackOnStart: false,
            delay: const Duration(milliseconds: 300),
            feedback: _EventDragFeedback(event: event, colors: colors),
            childWhenDragging: Opacity(opacity: 0.35, child: chip),
            child: chip,
          );

    return KeyedSubtree(
      key: Key('plex-cal-event-${event.id}'),
      child: body,
    );
  }
}

class _DayEventColumn extends StatelessWidget {
  const _DayEventColumn({
    required this.date,
    required this.events,
    required this.colors,
    required this.timeLabel,
    this.onEventTap,
    this.onEventMoved,
    this.onEventResized,
    this.onDropEvent,
  });

  final DateTime date;
  final List<PlexCalendarEvent> events;
  final PlexColorTokens colors;
  final String Function(PlexCalendarEvent) timeLabel;
  final ValueChanged<PlexCalendarEvent>? onEventTap;
  final ValueChanged<PlexCalendarEvent>? onEventMoved;
  final ValueChanged<PlexCalendarEvent>? onEventResized;
  final ValueChanged<PlexCalendarEvent>? onDropEvent;

  @override
  Widget build(BuildContext context) {
    final Widget column = Container(
      key: Key('plex-cal-day-${_yyyyMMdd(date)}'),
      constraints: const BoxConstraints(minHeight: PlexDim.extraLarge),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.borderSubtle),
          left: BorderSide(color: colors.borderSubtle),
        ),
      ),
      child: events.isEmpty
          ? const SizedBox(height: PlexDim.extraLarge)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final PlexCalendarEvent event in events)
                  _EventTile(
                    event: event,
                    colors: colors,
                    showDate: false,
                    showTime: true,
                    hourGutter: false,
                    compact: true,
                    timeLabel: timeLabel,
                    onTap:
                        onEventTap == null ? null : () => onEventTap!(event),
                    onEventMoved: onEventMoved,
                    onEventResized: onEventResized,
                  ),
              ],
            ),
    );

    if (onDropEvent == null) return column;

    return DragTarget<PlexCalendarEvent>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (DragTargetDetails<PlexCalendarEvent> details) {
        onDropEvent!(details.data);
      },
      builder: (
        BuildContext context,
        List<PlexCalendarEvent?> candidate,
        List<dynamic> rejected,
      ) {
        final bool hovering = candidate.isNotEmpty;
        return ColoredBox(
          color: hovering
              ? colors.brandPrimary.withValues(alpha: 0.08)
              : Colors.transparent,
          child: column,
        );
      },
    );
  }
}

class _HourSlot extends StatelessWidget {
  const _HourSlot({
    required this.hour,
    required this.events,
    required this.colors,
    required this.timeLabel,
    this.onEventTap,
    this.onEventMoved,
    this.onEventResized,
    this.onDropEvent,
  });

  final int hour;
  final List<PlexCalendarEvent> events;
  final PlexColorTokens colors;
  final String Function(PlexCalendarEvent) timeLabel;
  final ValueChanged<PlexCalendarEvent>? onEventTap;
  final ValueChanged<PlexCalendarEvent>? onEventMoved;
  final ValueChanged<PlexCalendarEvent>? onEventResized;
  final ValueChanged<PlexCalendarEvent>? onDropEvent;

  @override
  Widget build(BuildContext context) {
    final Widget slot = Container(
      key: Key('plex-cal-hour-$hour'),
      constraints: const BoxConstraints(minHeight: PlexDim.largeMinus),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.borderSubtle),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                PlexDim.small,
                PlexDim.smallest,
                PlexDim.smallest,
                PlexDim.smallest,
              ),
              child: Text(
                DateFormat.jm().format(DateTime(2026, 1, 1, hour)),
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: PlexFontSize.smallest,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final PlexCalendarEvent event in events)
                  _EventTile(
                    event: event,
                    colors: colors,
                    showDate: false,
                    showTime: true,
                    hourGutter: false,
                    timeLabel: timeLabel,
                    onTap:
                        onEventTap == null ? null : () => onEventTap!(event),
                    onEventMoved: onEventMoved,
                    onEventResized: onEventResized,
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onDropEvent == null) return slot;

    return DragTarget<PlexCalendarEvent>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (DragTargetDetails<PlexCalendarEvent> details) {
        onDropEvent!(details.data);
      },
      builder: (
        BuildContext context,
        List<PlexCalendarEvent?> candidate,
        List<dynamic> rejected,
      ) {
        final bool hovering = candidate.isNotEmpty;
        return ColoredBox(
          color: hovering
              ? colors.brandPrimary.withValues(alpha: 0.08)
              : Colors.transparent,
          child: slot,
        );
      },
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
  });

  final List<PlexCalendarEvent> events;
  final PlexColorTokens colors;
  final String emptyLabel;
  final bool showDate;
  final bool showTime;
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
              hourGutter: false,
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
    this.onEventMoved,
    this.onEventResized,
    this.compact = false,
  });

  final PlexCalendarEvent event;
  final PlexColorTokens colors;
  final bool showDate;
  final bool showTime;
  final bool hourGutter;
  final bool compact;
  final String Function(PlexCalendarEvent) timeLabel;
  final VoidCallback? onTap;
  final ValueChanged<PlexCalendarEvent>? onEventMoved;
  final ValueChanged<PlexCalendarEvent>? onEventResized;

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
          height: compact ? PlexDim.medium : PlexDim.largeMinus,
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
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: PlexFontSize.smallest,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Text(
                event.title,
                maxLines: compact ? 2 : 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: compact ? PlexFontSize.smallest : PlexFontSize.body,
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

    Widget block = InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? PlexDim.smallest : PlexDim.medium,
          compact ? PlexDim.smallest : PlexDim.small,
          compact ? PlexDim.smallest : PlexDim.medium,
          compact ? PlexDim.mini : PlexDim.small,
        ),
        child: body,
      ),
    );

    if (onEventMoved != null) {
      block = LongPressDraggable<PlexCalendarEvent>(
        data: event,
        hapticFeedbackOnStart: false,
        delay: const Duration(milliseconds: 300),
        feedback: _EventDragFeedback(event: event, colors: colors),
        childWhenDragging: Opacity(opacity: 0.35, child: block),
        child: block,
      );
    }

    if (onEventResized != null) {
      block = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          block,
          _ResizeHandle(
            event: event,
            accent: accent,
            onResized: onEventResized!,
          ),
        ],
      );
    }

    return KeyedSubtree(
      key: Key('plex-cal-event-${event.id}'),
      child: block,
    );
  }
}

class _ResizeHandle extends StatefulWidget {
  const _ResizeHandle({
    required this.event,
    required this.accent,
    required this.onResized,
  });

  final PlexCalendarEvent event;
  final Color accent;
  final ValueChanged<PlexCalendarEvent> onResized;

  @override
  State<_ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<_ResizeHandle> {
  DateTime? _originEnd;
  DateTime? _lastEnd;
  double _dy = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('plex-cal-resize-${widget.event.id}'),
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (_) {
        _originEnd = widget.event.end ??
            widget.event.start.add(const Duration(hours: 1));
        _lastEnd = _originEnd;
        _dy = 0;
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        final DateTime? origin = _originEnd;
        if (origin == null) return;
        _dy += details.delta.dy;
        final int steps = (_dy / PlexDim.medium).round();
        DateTime next = origin.add(Duration(minutes: 15 * steps));
        final DateTime minEnd =
            widget.event.start.add(const Duration(minutes: 15));
        if (next.isBefore(minEnd)) next = minEnd;
        _lastEnd = next;
      },
      onVerticalDragEnd: (_) {
        final DateTime? end = _lastEnd;
        if (end == null) return;
        final DateTime? previous = widget.event.end;
        if (previous != null && end.isAtSameMomentAs(previous)) return;
        widget.onResized(widget.event.copyWith(end: end));
      },
      child: SizedBox(
        height: PlexDim.medium,
        child: Center(
          child: Container(
            width: PlexDim.large,
            height: PlexDim.mini + 2,
            decoration: BoxDecoration(
              color: widget.accent,
              borderRadius: BorderRadius.circular(PlexRadius.pill),
            ),
          ),
        ),
      ),
    );
  }
}

class _EventDragFeedback extends StatelessWidget {
  const _EventDragFeedback({
    required this.event,
    required this.colors,
  });

  final PlexCalendarEvent event;
  final PlexColorTokens colors;

  @override
  Widget build(BuildContext context) {
    final Color accent = event.color ?? colors.brandPrimary;
    return Material(
      elevation: PlexElevation.md,
      color: colors.surfaceCard,
      borderRadius: BorderRadius.circular(PlexRadius.sm),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: PlexDim.small,
          vertical: PlexDim.smallest,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(PlexRadius.sm),
          border: Border.all(color: accent),
        ),
        child: Text(
          event.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: PlexFontSize.caption,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

String _yyyyMMdd(DateTime value) {
  final String y = value.year.toString().padLeft(4, '0');
  final String m = value.month.toString().padLeft(2, '0');
  final String d = value.day.toString().padLeft(2, '0');
  return '$y$m$d';
}

bool _inInclusiveDateRange(DateTime start, DateTime from, DateTime to) {
  final DateTime day = _dateOnly(start);
  return !day.isBefore(from) && !day.isAfter(to);
}

PlexCalendarEvent _shiftEvent(PlexCalendarEvent event, DateTime newStart) {
  final DateTime? end = event.end;
  return event.copyWith(
    start: newStart,
    end: end == null ? null : newStart.add(end.difference(event.start)),
  );
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// A single event for [PlexCalendar].
class PlexCalendarEvent {
  const PlexCalendarEvent({
    required this.title,
    required this.start,
    required this.end,
    this.color,
    this.data,
  });

  final String title;
  final DateTime start;
  final DateTime end;
  final Color? color;
  final dynamic data;
}

/// Calendar view mode.
enum PlexCalendarView {
  month,
  week,
  day,
}

/// A calendar widget built on Syncfusion SfCalendar.
class PlexCalendar extends StatelessWidget {
  const PlexCalendar({
    super.key,
    required this.events,
    this.initialView = PlexCalendarView.month,
    this.onEventTap,
    this.onSlotTap,
    this.allowDragging = false,
  });

  final List<PlexCalendarEvent> events;
  final PlexCalendarView initialView;
  final void Function(PlexCalendarEvent event)? onEventTap;
  final void Function(DateTime dateTime)? onSlotTap;
  final bool allowDragging;

  static CalendarView _toSfView(PlexCalendarView v) {
    return switch (v) {
      PlexCalendarView.month => CalendarView.month,
      PlexCalendarView.week => CalendarView.week,
      PlexCalendarView.day => CalendarView.day,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.primary;

    final appointments = <Appointment>[];
    for (var i = 0; i < events.length; i++) {
      final e = events[i];
      appointments.add(
        Appointment(
          id: i,
          startTime: e.start,
          endTime: e.end,
          subject: e.title,
          color: e.color ?? defaultColor,
        ),
      );
    }

    final dataSource = _PlexCalendarDataSource(appointments);

    return SfCalendar(
      view: _toSfView(initialView),
      dataSource: dataSource,
      allowAppointmentResize: allowDragging,
      allowDragAndDrop: allowDragging,
      onTap: (CalendarTapDetails details) {
        if (details.appointments != null && details.appointments!.isNotEmpty) {
          final apt = details.appointments!.first;
          final idx = apt.id is int ? apt.id as int : null;
          if (idx != null && idx >= 0 && idx < events.length) {
            onEventTap?.call(events[idx]);
          }
        } else if (details.date != null) {
          onSlotTap?.call(details.date!);
        }
      },
    );
  }
}

class _PlexCalendarDataSource extends CalendarDataSource {
  _PlexCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}

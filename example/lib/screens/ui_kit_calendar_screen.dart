import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_calendar.dart';
import 'package:plex_app/screens/example_chrome.dart';

class UiKitCalendarScreen extends StatefulWidget {
  const UiKitCalendarScreen({super.key});

  @override
  State<UiKitCalendarScreen> createState() => _UiKitCalendarScreenState();
}

class _UiKitCalendarScreenState extends State<UiKitCalendarScreen> {
  DateTime? _selected = DateTime(2026, 8, 15);
  PlexCalendarView _view = PlexCalendarView.month;
  String? _lastEvent;

  static final List<PlexCalendarEvent> _events = <PlexCalendarEvent>[
    PlexCalendarEvent(
      id: 'aug-standup',
      start: DateTime(2026, 8, 3, 9),
      end: DateTime(2026, 8, 3, 9, 30),
      title: 'Planning standup',
      color: Color(0xFF2563EB),
      recurrence: PlexCalendarRecurrence.daily(count: 5),
    ),
    PlexCalendarEvent(
      id: 'aug-vendor',
      start: DateTime(2026, 8, 12, 11),
      end: DateTime(2026, 8, 12, 12),
      title: 'Vendor call',
      color: Color(0xFF0F766E),
    ),
    PlexCalendarEvent(
      id: 'aug-design',
      start: DateTime(2026, 8, 15, 9, 30),
      end: DateTime(2026, 8, 15, 11),
      title: 'Design review',
    ),
    PlexCalendarEvent(
      id: 'aug-sprint',
      start: DateTime(2026, 8, 15, 14),
      end: DateTime(2026, 8, 15, 14, 45),
      title: 'Sprint check-in',
      color: Color(0xFFD97706),
    ),
    PlexCalendarEvent(
      id: 'aug-ship',
      start: DateTime(2026, 8, 20, 16),
      title: 'Ship cutoff',
      color: Color(0xFFDC2626),
    ),
    PlexCalendarEvent(
      id: 'aug-retro',
      start: DateTime(2026, 8, 28, 10),
      end: DateTime(2026, 8, 28, 11),
      title: 'Retro',
      color: Color(0xFF7C3AED),
    ),
  ];

  static const Map<PlexCalendarView, String> _viewLabels =
      <PlexCalendarView, String>{
    PlexCalendarView.month: 'Month',
    PlexCalendarView.week: 'Week',
    PlexCalendarView.day: 'Day',
    PlexCalendarView.agenda: 'Agenda',
  };

  String _selectedLabel() {
    final DateTime? selected = _selected;
    if (selected == null) return "Tap a day in the current month.";
    final String month = selected.month.toString().padLeft(2, "0");
    final String day = selected.day.toString().padLeft(2, "0");
    return "Selected: ${selected.year}-$month-$day";
  }

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;

    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "PlexCalendar",
          subtitle:
              "Week, day, and agenda now exist. Not a replacement for PlexFormFieldDate.",
          actions: const PlexBadge(label: "Phase 7", tone: PlexBadgeTone.info),
          child: Text(
            "Month stays the default. Switch views below; event rows call onEventTap.",
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "August 2026",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: PlexDim.small,
                runSpacing: PlexDim.smallest,
                children: [
                  for (final PlexCalendarView view in PlexCalendarView.values)
                    TextButton(
                      onPressed: () => setState(() => _view = view),
                      child: Text(
                        _viewLabels[view]!,
                        style: TextStyle(
                          fontWeight:
                              _view == view ? FontWeight.w700 : FontWeight.w500,
                          color: _view == view
                              ? colors.brandPrimary
                              : colors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: PlexDim.small),
              PlexCalendar(
                selected: _selected,
                focusedMonth: DateTime(2026, 8, 1),
                view: _view,
                events: _events,
                onSelected: (date) => setState(() => _selected = date),
                onEventTap: (event) => setState(() => _lastEvent = event.title),
                onEventMoved: (event) => setState(() =>
                    _lastEvent = '${event.title} → ${event.start}'),
                onEventResized: (event) => setState(() =>
                    _lastEvent = '${event.title} ends ${event.end}'),
              ),
              const SizedBox(height: PlexDim.medium),
              Text(
                _selectedLabel(),
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_lastEvent != null) ...[
                const SizedBox(height: PlexDim.smallest),
                Text(
                  "Event: $_lastEvent",
                  style: TextStyle(color: colors.textSecondary),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

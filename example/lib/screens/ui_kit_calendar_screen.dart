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
          subtitle: "Month view only. Not a replacement for PlexFormFieldDate.",
          actions: const PlexBadge(label: "Phase 7", tone: PlexBadgeTone.info),
          child: Text(
            "Week, day, and agenda views are not part of this widget.",
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "August 2026",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PlexCalendar(
                selected: _selected,
                focusedMonth: DateTime(2026, 8, 1),
                onSelected: (date) => setState(() => _selected = date),
              ),
              const SizedBox(height: PlexDim.medium),
              Text(
                _selectedLabel(),
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

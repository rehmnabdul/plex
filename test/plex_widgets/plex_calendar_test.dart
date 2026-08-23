import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_calendar.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
    ),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('builds month view for focusedMonth', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexCalendar(focusedMonth: DateTime(2026, 8, 1)),
      ),
    );

    expect(find.text('15'), findsAtLeastNWidgets(1));
    final hasHeading = find.textContaining('August').evaluate().isNotEmpty ||
        find.textContaining('Aug').evaluate().isNotEmpty ||
        find.textContaining('2026').evaluate().isNotEmpty;
    expect(hasHeading, isTrue);
  });

  testWidgets('tapping a day calls onSelected', (tester) async {
    DateTime? selected;
    await tester.pumpWidget(
      _wrap(
        PlexCalendar(
          focusedMonth: DateTime(2026, 8, 1),
          onSelected: (date) => selected = date,
        ),
      ),
    );

    await tester.tap(find.text('15').first);
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
    expect(selected!.year, 2026);
    expect(selected!.month, 8);
    expect(selected!.day, 15);
  });

  testWidgets('builds with selected date', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexCalendar(
          focusedMonth: DateTime(2026, 8, 1),
          selected: DateTime(2026, 8, 15),
        ),
      ),
    );

    expect(find.byType(PlexCalendar), findsOneWidget);
  });

  testWidgets('month with events still shows day 15 and onSelected',
      (tester) async {
    DateTime? selected;
    await tester.pumpWidget(
      _wrap(
        PlexCalendar(
          focusedMonth: DateTime(2026, 8, 1),
          events: [
            PlexCalendarEvent(
              id: '1',
              start: DateTime(2026, 8, 15, 9),
              title: 'Line A standup',
            ),
          ],
          onSelected: (date) => selected = date,
        ),
      ),
    );

    expect(find.text('15'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('15').first);
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
    expect(selected!.year, 2026);
    expect(selected!.month, 8);
    expect(selected!.day, 15);
  });

  testWidgets('agenda view shows event title', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexCalendar(
          focusedMonth: DateTime(2026, 8, 1),
          view: PlexCalendarView.agenda,
          events: [
            PlexCalendarEvent(
              id: '1',
              start: DateTime(2026, 8, 15, 9),
              title: 'Line A standup',
            ),
          ],
        ),
      ),
    );
    expect(find.text('Line A standup'), findsOneWidget);
  });

  testWidgets('week and day views build', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexCalendar(
          focusedMonth: DateTime(2026, 8, 1),
          selected: DateTime(2026, 8, 15),
          view: PlexCalendarView.week,
          events: [
            PlexCalendarEvent(
              id: '1',
              start: DateTime(2026, 8, 15, 9),
              title: 'Line A standup',
            ),
          ],
        ),
      ),
    );
    expect(find.byType(PlexCalendar), findsOneWidget);

    await tester.pumpWidget(
      _wrap(
        PlexCalendar(
          focusedMonth: DateTime(2026, 8, 1),
          selected: DateTime(2026, 8, 15),
          view: PlexCalendarView.day,
        ),
      ),
    );
    expect(find.byType(PlexCalendar), findsOneWidget);
  });

  test('daily recurrence expand yields three occurrences', () {
    final PlexCalendarEvent event = PlexCalendarEvent(
      id: 'standup',
      start: DateTime(2026, 8, 15, 9),
      title: 'Line A standup',
      recurrence: PlexCalendarRecurrence.daily(count: 3),
    );
    final List<PlexCalendarEvent> expanded = PlexCalendarRecurrence.expand(
      event,
      rangeStart: DateTime(2026, 8, 1),
      rangeEnd: DateTime(2026, 8, 31),
    );

    expect(expanded, hasLength(3));
    expect(
      expanded
          .map((PlexCalendarEvent e) =>
              DateTime(e.start.year, e.start.month, e.start.day))
          .toList(),
      <DateTime>[
        DateTime(2026, 8, 15),
        DateTime(2026, 8, 16),
        DateTime(2026, 8, 17),
      ],
    );
  });

  testWidgets('recurring event appears more than once in August 2026',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 900,
          height: 800,
          child: PlexCalendar(
            focusedMonth: DateTime(2026, 8, 1),
            view: PlexCalendarView.agenda,
            events: [
              PlexCalendarEvent(
                id: 'standup',
                start: DateTime(2026, 8, 15, 9),
                title: 'Line A standup',
                recurrence: PlexCalendarRecurrence.daily(count: 3),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Line A standup'), findsAtLeastNWidgets(2));
  });

  testWidgets('dragging week event calls onEventMoved', (tester) async {
    PlexCalendarEvent? moved;
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 900,
          height: 800,
          child: PlexCalendar(
            focusedMonth: DateTime(2026, 8, 1),
            selected: DateTime(2026, 8, 15),
            view: PlexCalendarView.week,
            onEventMoved: (PlexCalendarEvent event) => moved = event,
            events: [
              PlexCalendarEvent(
                id: '1',
                start: DateTime(2026, 8, 15, 9),
                title: 'Line A standup',
              ),
            ],
          ),
        ),
      ),
    );

    final Finder eventFinder = find.byKey(const Key('plex-cal-event-1'));
    expect(eventFinder, findsOneWidget);
    final TestGesture gesture =
        await tester.startGesture(tester.getCenter(eventFinder));
    await tester.pump(const Duration(milliseconds: 400));
    await gesture.moveBy(const Offset(160, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(moved, isNotNull);
  });
}

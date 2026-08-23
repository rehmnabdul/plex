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
}

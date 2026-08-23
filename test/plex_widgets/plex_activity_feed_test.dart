import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_activity_feed.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  final DateTime now = DateTime(2026, 8, 23, 15, 30);

  testWidgets('builds title and body', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexActivityFeed(
          now: now,
          items: [
            PlexActivityItem(
              id: '1',
              title: 'Lot approved',
              time: now.subtract(const Duration(minutes: 5)),
              body: 'QA signed off WO-1042',
            ),
          ],
        ),
      ),
    );
    expect(find.text('Lot approved'), findsOneWidget);
    expect(find.text('QA signed off WO-1042'), findsOneWidget);
  });

  testWidgets('relative time label is visible', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexActivityFeed(
          now: now,
          items: [
            PlexActivityItem(
              id: '1',
              title: 'Comment added',
              time: now.subtract(const Duration(minutes: 12)),
            ),
          ],
        ),
      ),
    );
    expect(find.text('12m ago'), findsOneWidget);
  });

  testWidgets('loading shows skeleton without item titles', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexActivityFeed(
          loading: true,
          items: [],
        ),
      ),
    );
    expect(find.text('Lot approved'), findsNothing);
    expect(find.text('Nothing here yet'), findsNothing);
  });

  testWidgets('emptyTitle when items empty and not loading', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexActivityFeed(
          items: [],
          emptyTitle: 'No activity',
        ),
      ),
    );
    expect(find.text('No activity'), findsOneWidget);
  });

  testWidgets('groupByDay shows Today for same-day items', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexActivityFeed(
          now: now,
          groupByDay: true,
          items: [
            PlexActivityItem(
              id: '1',
              title: 'Shift started',
              time: now.subtract(const Duration(hours: 2)),
            ),
          ],
        ),
      ),
    );
    expect(find.text('Today'), findsOneWidget);
  });
}

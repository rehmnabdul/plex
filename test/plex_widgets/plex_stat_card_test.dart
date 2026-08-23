import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_stat_card.dart';

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
  testWidgets('PlexStatCard builds with label and value', (tester) async {
    await tester.pumpWidget(
      _wrap(const PlexStatCard(label: 'Orders', value: '128')),
    );
    expect(find.text('ORDERS'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
  });

  testWidgets('PlexStatCard onTap fires', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        PlexStatCard(
          label: 'Tap',
          value: '1',
          onTap: () => tapped = true,
        ),
      ),
    );
    await tester.tap(find.text('1'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('PlexStatTile builds label and value', (tester) async {
    await tester.pumpWidget(
      _wrap(const PlexStatTile(label: 'Revenue', value: '4.2k')),
    );
    expect(find.text('REVENUE'), findsOneWidget);
    expect(find.text('4.2k'), findsOneWidget);
  });

  testWidgets('PlexStatGrid builds multiple tiles', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexStatGrid(
          children: [
            PlexStatTile(label: 'A', value: '1'),
            PlexStatTile(label: 'B', value: '2'),
          ],
        ),
      ),
    );
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('PlexProgressRing shows derived percent', (tester) async {
    await tester.pumpWidget(
      _wrap(const PlexProgressRing(value: 50, max: 100)),
    );
    expect(find.text('50%'), findsOneWidget);
  });

  testWidgets('PlexProgressRing custom display replaces percent', (tester) async {
    await tester.pumpWidget(
      _wrap(const PlexProgressRing(value: 50, display: 'On track')),
    );
    expect(find.text('On track'), findsOneWidget);
    expect(find.text('50%'), findsNothing);
  });

  testWidgets('delta text is visible', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexStatCard(
          label: 'Defects',
          value: '3',
          delta: '+4.2%',
          direction: PlexStatDirection.up,
        ),
      ),
    );
    expect(find.text('+4.2%'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_badge.dart';

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
  testWidgets('each badge tone builds with its label', (tester) async {
    for (final PlexBadgeTone tone in PlexBadgeTone.values) {
      await tester.pumpWidget(
        _wrap(PlexBadge(label: tone.name, tone: tone)),
      );
      expect(find.text(tone.name), findsOneWidget);
      expect(find.byType(PlexBadge), findsOneWidget);
    }
  });

  testWidgets('each appearance builds', (tester) async {
    for (final PlexBadgeAppearance appearance in PlexBadgeAppearance.values) {
      await tester.pumpWidget(
        _wrap(
          PlexBadge(
            label: appearance.name,
            appearance: appearance,
            tone: PlexBadgeTone.info,
          ),
        ),
      );
      expect(find.text(appearance.name), findsOneWidget);
    }
  });

  testWidgets('dot and square flags still render the label', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexBadge(
          label: 'Live',
          tone: PlexBadgeTone.success,
          dot: true,
          square: true,
        ),
      ),
    );
    expect(find.text('Live'), findsOneWidget);
  });
}

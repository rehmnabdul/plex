import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_shimmer.dart';

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
  testWidgets('PlexShimmer still builds', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexShimmer(
          child: SizedBox(width: 40, height: 12),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(PlexShimmer), findsOneWidget);
  });

  testWidgets('PlexSkeleton presets still build', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Column(
          children: [
            PlexSkeleton.line(width: 80),
            PlexSkeleton.circle(size: 24),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(PlexSkeleton), findsNWidgets(2));
    expect(find.byType(PlexShimmer), findsNWidgets(2));
  });
}

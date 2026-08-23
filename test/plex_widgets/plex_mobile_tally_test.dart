import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_mobile_tally.dart';

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
  testWidgets('typing item id and submit calls onIncrement', (tester) async {
    PlexMobileTallyItem? hit;
    await tester.pumpWidget(
      _wrap(
        PlexMobileTally(
          enableScanner: false,
          items: const [
            PlexMobileTallyItem(id: 'A-1042', title: 'A-1042', qty: 2),
          ],
          onIncrement: (PlexMobileTallyItem item) => hit = item,
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('plex-mobile-tally-code')),
      'A-1042',
    );
    await tester.tap(find.byKey(const Key('plex-mobile-tally-submit')));
    await tester.pump();

    expect(hit?.id, 'A-1042');
  });
}

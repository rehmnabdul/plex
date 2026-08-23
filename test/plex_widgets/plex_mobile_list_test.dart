import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_mobile_list.dart';

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
  testWidgets('increment tap fires onIncrement', (tester) async {
    PlexMobileTallyItem? hit;
    await tester.pumpWidget(
      _wrap(
        PlexMobileList(
          items: const [
            PlexMobileTallyItem(id: 'a', title: 'A-1042', qty: 2),
          ],
          onIncrement: (PlexMobileTallyItem item) => hit = item,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('plex-mobile-inc-a')));
    await tester.pump();
    expect(hit?.id, 'a');
  });
}

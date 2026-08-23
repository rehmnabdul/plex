import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_lookup.dart';

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
  testWidgets('selecting a lookup item fires onChanged', (tester) async {
    String? picked;
    await tester.pumpWidget(
      _wrap(
        PlexLookup<String>(
          items: const ['SKU-1', 'SKU-2', 'A-1042'],
          labelOf: (String item) => item,
          onChanged: (String? value) => picked = value,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('plex-lookup-field')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('plex-lookup-search')), '1042');
    await tester.pump();

    await tester.tap(find.byKey(const Key('plex-lookup-item-A-1042')));
    await tester.pumpAndSettle();

    expect(picked, 'A-1042');
  });
}

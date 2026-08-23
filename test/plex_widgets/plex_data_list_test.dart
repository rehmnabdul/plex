import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_data_list.dart';

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
  testWidgets('builds title and subtitle', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexDataList(
          items: [
            PlexDataListItem(title: 'WO-1042', subtitle: 'Cutting line'),
          ],
        ),
      ),
    );
    expect(find.text('WO-1042'), findsOneWidget);
    expect(find.text('Cutting line'), findsOneWidget);
  });

  testWidgets('value trailing is visible', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexDataList(
          items: [
            PlexDataListItem(title: 'SKU-9', value: '84 pcs'),
          ],
        ),
      ),
    );
    expect(find.text('84 pcs'), findsOneWidget);
  });

  testWidgets('onItemTap fires', (tester) async {
    String? tapped;
    await tester.pumpWidget(
      _wrap(
        PlexDataList(
          items: const [
            PlexDataListItem(title: 'Tap row'),
          ],
          onItemTap: (item, index) => tapped = item.title,
        ),
      ),
    );
    await tester.tap(find.text('Tap row'));
    await tester.pump();
    expect(tapped, 'Tap row');
  });

  testWidgets('check variant onToggle fires', (tester) async {
    var toggled = false;
    await tester.pumpWidget(
      _wrap(
        PlexDataList(
          variant: PlexDataListVariant.check,
          items: const [
            PlexDataListItem(title: 'Inspect lot', done: false),
          ],
          onToggle: (item, index) => toggled = true,
        ),
      ),
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(toggled, isTrue);
  });
}

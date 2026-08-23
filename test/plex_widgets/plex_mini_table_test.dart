import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_mini_table.dart';

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
  testWidgets('builds headers and cell strings', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexMiniTable(
          columns: [
            PlexMiniTableColumn(id: 'sku', header: 'Sku'),
            PlexMiniTableColumn(id: 'qty', header: 'Qty', numeric: true),
          ],
          rows: [
            ['A-100', '12'],
            ['B-200', '4'],
          ],
        ),
      ),
    );
    expect(find.text('SKU'), findsOneWidget);
    expect(find.text('QTY'), findsOneWidget);
    expect(find.text('A-100'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
  });

  testWidgets('emptyMessage when rows are empty', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexMiniTable(
          columns: [PlexMiniTableColumn(id: 'sku', header: 'Sku')],
          rows: [],
          emptyMessage: 'No lines',
        ),
      ),
    );
    expect(find.text('No lines'), findsOneWidget);
    expect(find.text('SKU'), findsNothing);
  });

  testWidgets('onRowTap fires with index 0', (tester) async {
    int? tapped;
    await tester.pumpWidget(
      _wrap(
        PlexMiniTable(
          columns: const [
            PlexMiniTableColumn(id: 'sku', header: 'Sku'),
          ],
          rows: const [
            ['A-100'],
            ['B-200'],
          ],
          onRowTap: (int index) => tapped = index,
        ),
      ),
    );
    await tester.tap(find.text('A-100'));
    await tester.pump();
    expect(tapped, 0);
  });
}

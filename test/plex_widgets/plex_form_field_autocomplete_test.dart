import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

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
  testWidgets('existing constructor still builds', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldAutoComplete<String>(
          properties: const PlexFormFieldGeneric.title('Search'),
          autoCompleteItems: (query) async => <String>['A'],
        ),
      ),
    );
    expect(find.byType(PlexFormFieldAutoComplete<String>), findsOneWidget);
    expect(find.text('N/A'), findsOneWidget);
  });

  testWidgets('shows selected value from controller', (tester) async {
    final PlexWidgetController<String?> controller =
        PlexWidgetController<String?>(data: 'Apple');
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldAutoComplete<String>(
          properties:
              const PlexFormFieldGeneric(title: 'Search', useMargin: false),
          dropdownSelectionController: controller,
          autoCompleteItems: (query) async => <String>['Apple', 'Banana'],
        ),
      ),
    );
    expect(find.text('Apple'), findsOneWidget);
  });

  testWidgets('custom noDataText is shown when empty', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldAutoComplete<String>(
          properties:
              const PlexFormFieldGeneric(title: 'Search', useMargin: false),
          noDataText: 'Nothing yet',
          autoCompleteItems: (query) async => <String>[],
        ),
      ),
    );
    expect(find.text('Nothing yet'), findsOneWidget);
  });
}

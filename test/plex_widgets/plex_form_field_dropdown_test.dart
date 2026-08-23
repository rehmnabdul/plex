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
  testWidgets('existing constructor still builds with items', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldDropdown<String>(
          properties: const PlexFormFieldGeneric.title('Pick'),
          dropdownItems: const ['A', 'B'],
        ),
      ),
    );
    expect(find.byType(PlexFormFieldDropdown<String>), findsOneWidget);
    expect(find.text('N/A'), findsOneWidget);
  });

  testWidgets('initialSelection is shown', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldDropdown<String>(
          properties:
              const PlexFormFieldGeneric(title: 'Pick', useMargin: false),
          dropdownItems: const ['Alpha', 'Beta'],
          initialSelection: 'Beta',
        ),
      ),
    );
    expect(find.text('Beta'), findsOneWidget);
  });

  testWidgets('showClearButton clears the selection', (tester) async {
    final PlexWidgetController<String?> controller =
        PlexWidgetController<String?>(data: 'Alpha');
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldDropdown<String>(
          properties:
              const PlexFormFieldGeneric(title: 'Pick', useMargin: false),
          dropdownItems: const ['Alpha', 'Beta'],
          dropdownSelectionController: controller,
          showClearButton: true,
        ),
      ),
    );
    expect(find.text('Alpha'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(controller.data, isNull);
    expect(find.text('N/A'), findsOneWidget);
  });

  testWidgets('disabled dropdown still builds', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldDropdown<String>(
          properties: const PlexFormFieldGeneric(
            title: 'Pick',
            enabled: false,
            useMargin: false,
          ),
          dropdownItems: const ['A'],
        ),
      ),
    );
    expect(find.text('Pick'), findsOneWidget);
  });
}
